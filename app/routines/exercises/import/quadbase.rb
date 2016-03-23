module Exercises
  module Import
    class Quadbase

      lev_routine

      uses_routine OpenStax::Accounts::FindOrCreateAccount,
                   translations: { outputs: { type: :verbatim } },
                   as: :find_or_create_account

      QUADBASE_URL = 'https://quadbase.org'
      QUADBASE_QUESTIONS_URL = "#{QUADBASE_URL}/questions/q"

      ATTACHMENT_EXTENSIONS = ['jpeg', 'jpg', 'png', 'gif', 'pdf']
      FILENAME_EXPRESSION = "[\\w-]+\\.(?:#{ATTACHMENT_EXTENSIONS.join('|')})"
      QUADBASE_ATTACHMENTS_REGEX = Regexp.new "<p><center><img src=\\\"(#{QUADBASE_URL}/system/attachments/[\\d]+/medium/#{FILENAME_EXPRESSION})\\\"></center></p>"
      QUADBASE_MATH_REGEX = /(\${1,2})[^\$]+\1/m

      def exec(id: nil, range: nil, file: nil)
        fatal_error(code: :no_args,
                    message: 'Must specify a question id, a range or a file to import') \
          if id.nil? && range.nil? && file.nil?

        remote_import_question(id) unless id.nil?

        remote_import_range(range) unless range.nil?

        import_file(file) unless file.nil?
      end

      # Imports and saves a Quadbase question as an Exercise
      # Returns true if the Exercise was saved or false otherwise
      def import_question(hash)
        if hash['multipart_question']
          hash = hash['multipart_question']
          exercise = import_multipart(hash)
        elsif hash['simple_question']
          hash = hash['simple_question']
          exercise = import_simple(hash)
        end
        id_tag = "exid:qb:#{hash['id']}"

        latest_exercise = Exercise.joins([:publication, exercise_tags: :tag])
                                  .where(exercise_tags: {tag: {name: id_tag}})
                                  .order{[publication.number.desc, publication.version.desc]}.first

        publication = import_metadata(hash['attribution'])

        unless latest_exercise.nil?
          publication.number = latest_exercise.publication.number
          publication.version = latest_exercise.publication.version + 1
        end

        publication.publishable = exercise
        exercise.publication = publication
        exercise.tags = [id_tag] + convert_tags(hash)

        list_name = (hash['lists'] || []).first

        if list_name.present?
          list = List.find_by(name: list_name)
          if list.nil?
            list = List.create(name: list_name)

            (publication.authors.map(&:user) + \
             publication.copyright_holders.map(&:user)).uniq.each do |user|
              lo = ListOwner.new
              lo.owner = user
              lo.list = list
              list.list_owners << lo
            end

            list.save!
            Rails.logger.info "Created new list: #{list_name}"
          end

          le = ListExercise.new
          le.exercise = exercise
          le.list = list
          exercise.list_exercises << le
          list.list_exercises << le
        end

        exercise.save!

        if exercise.content_equals?(latest_exercise)
          exercise.destroy
          skipped = true
        else
          skipped = false
        end

        ex = "Imported Exercise #{hash['id']}"
        uid = skipped ? "Existing uid: #{latest_exercise.uid}" : "New uid: #{exercise.uid}"
        changes = skipped ? "Exercise skipped (no changes)" : \
                            "New #{latest_exercise.nil? ? 'exercise' : 'version'}"
        Rails.logger.info "#{ex} - #{uid} - #{changes}"
      end

      # Imports Quadbase questions from the given file
      def import_file(file)
        json = File.open(file, 'r') { |ff| ff.read }
        hash = JSON.parse(json)
        questions = hash['questions']
        puts "Importing #{questions.length} exercises"
        questions.each { |qq| import_question(qq) }
      end

      # Imports a Quadbase question by question ID
      # Returns true if the Exercise was saved or false otherwise
      def remote_import_question(id)
        id = id.to_s
        id[0] = '' if id[0] == 'q'

        url = "#{QUADBASE_QUESTIONS_URL}#{id}.json"
        content = Net::HTTP.get(URI.parse(url))
        return false if content.blank?

        import_question(JSON.parse(content))
      end

      # Imports all Quadbase questions in the given ID range
      def remote_import_range(id_range)
        puts 'Importing...'
        Exercise.transaction do
          for id in id_range
            puts "Question q#{id}"
            remote_import_question(id)
          end
        end
        puts 'Done.'
      end

      protected

      # Returns the license to be applied to quadbase questions
      def default_license
        @@default_license ||= License.find_by(name: 'cc_by_4_0')
      end

      # Gets the new CNX id for a legacy CNX id
      def get_cnx_id(legacy_id)
        @cnx_ids ||= {}
        new_id = @cnx_ids[legacy_id]
        return new_id unless new_id.nil?

        archive_url = "https://archive.cnx.org/content/#{legacy_id}"
        new_url = Net::HTTP.get_response(URI.parse(archive_url))['Location']
        matches = /\Ahttps?:\/\/archive.cnx.org\/contents\/([\w-]+)/.match(new_url) || []
        @cnx_ids[legacy_id] = matches[1]
      end

      # Copies the file in the given url to S3
      # Returns the new file url
      def copy_attachment(attachable, url)
        outputs = AttachFile.call(attachable: attachable, url: url).outputs
        outputs[:large_url] || outputs[:url]
      end

      # Converts Quadbase's dollar sign math to a math tag
      def math_tag(math)
        inner_math = math[1..-2]
        tag = 'span'
        if QUADBASE_MATH_REGEX =~ inner_math
          inner_math = inner_math[1..-2]
          tag = 'div'
        end
        escaped_math = Rack::Utils.escape_html(inner_math)

        "<#{tag} data-math=\"#{escaped_math}\">#{escaped_math}</#{tag}>"
      end

      # Converts Quadbase HTML to Exercises HTML
      def convert_html(attachable, html)
        attachments = html.to_s.scan(QUADBASE_ATTACHMENTS_REGEX)
        attachments.each do |matches|
          url = matches.first
          html = html.gsub(url, copy_attachment(attachable, url))
        end
        maths = html.scan(QUADBASE_MATH_REGEX)
        maths.each do |matches|
          math = matches.first
          html = html.gsub(math, math_tag(math))
        end
        html
      end

      # Imports a collaborator (requires username, email attributes in the hash)
      # Returns the collaborator
      def import_collaborator(hash, klass)
        username = hash['username']
        email = hash['email']
        name = hash['name']

        # Username is only available in files exported using the rake questions:export:json task
        return if username.nil?

        # Minimize calls to Accounts and DB queries
        @collaborator_users ||= {}
        user = @collaborator_users[username]
        if user.nil?
          account = run(:find_or_create_account, username: username, email: email).outputs.account
          account.update_column :full_name, name

          user = User.find_or_create_by(account: account)
          @collaborator_users[username] = user
        end

        collaborator = klass.new(user: user)
        collaborator
      end

      # Imports collaborators, licenses, etc
      # Returns a Publication
      def import_metadata(hash)
        publication = Publication.new
        publication.license = default_license

        (hash['authors'] || []).each do |author|
          c = import_collaborator(author, Author)
          publication.authors << c unless c.nil?
        end
        (hash['copyright_holders'] || []).each do |cr|
          c = import_collaborator(cr, CopyrightHolder)
          publication.copyright_holders << c unless c.nil?
        end

        publication
      end

      # Imports the introduction for a Quadbase question
      # Returns an Exercise
      def import_introduction(hash)
        exercise = Exercise.new
        exercise.stimulus = convert_html(exercise, hash['html']) unless hash.nil?
        exercise
      end

      # Imports a Quadbase question without the introduction
      # Returns the Question
      def import_without_introduction(attachable, hash)
        question = Question.new
        stem = Stem.new(question: question,
                        content: convert_html(attachable, hash['content']['html']))

        stem.stylings << Styling.new(stylable: stem, style: Style::DRAWING) \
          if hash['answer_can_be_sketched']

        if hash['answer_choices']
          stem.stylings << Styling.new(stylable: stem, style: Style::MULTIPLE_CHOICE)

          hash['answer_choices'].each do |ac|
            answer = Answer.new(question: question, content: convert_html(attachable, ac['html']))
            question.answers << answer
            stem.stem_answers << StemAnswer.new(stem: stem, answer: answer,
                                                correctness: ac['credit'])
          end
        else
          stem.stylings << Styling.new(stylable: stem, style: Style::FREE_RESPONSE)
        end

        question.stems << stem
        question
      end

      # Imports a simple question
      # Returns an Exercise
      def import_simple(hash)
        exercise = import_introduction(hash['introduction'])
        question = import_without_introduction(exercise, hash)
        question.exercise = exercise
        exercise.questions << question
        exercise
      end

      # Imports a multipart question
      # Returns an Exercise
      def import_multipart(hash)
        exercise = import_introduction(hash['introduction'])
        id_map = {}
        dependency_map = {}

        # First construct all question objects and the maps
        hash['parts'].each do |p|
          question = import_without_introduction(exercise, p['simple_question'])
          question.exercise = exercise
          id_map[p['simple_question']['id']] = question
          prerequisites = (p['prerequisites'] || []).collect{|pre| pre['id']}
          supports = (p['supported_by'] || []).collect{|pre| pre['id']}
          dependency_map[question] = {prerequisites: prerequisites, supports: supports}
          exercise.questions << question
        end

        # Then assign question dependencies
        dependency_map.each do |question, ds|
          ds[:prerequisites].each do |d|
            pq = id_map.delete(d)
            next if pq.nil?
            dependency = QuestionDependency.new(parent_question: pq,
                                                dependent_question: question,
                                                is_optional: false)
            question.parent_dependencies << dependency
          end

          ds[:supports].each do |d|
            pq = id_map.delete(d)
            next if pq.nil?
            dependency = QuestionDependency.new(parent_question: pq,
                                                dependent_question: question,
                                                is_optional: true)
            question.parent_dependencies << dependency
          end
        end

        exercise
      end

      # Converts Quadbase tags to Exercises tags
      def convert_tags(hash)
        tags = hash['tags'] || []
        filter_tag = "filter-type:qb"

        module_tag = tags.find{ |tag| /\Am\d+\z/.match tag }
        if module_tag.nil?
          cnxmod_tag = nil
          Rails.logger.warn "No cnxmod tag for #{hash['id']}"
        else
          cnx_id = get_cnx_id(module_tag)
          cnxmod_tag = "cnxmod:#{cnx_id}"
        end

        [filter_tag, cnxmod_tag].compact + tags.map{ |tag| "qb:#{tag}" }
      end

    end
  end
end
