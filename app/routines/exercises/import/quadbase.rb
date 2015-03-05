module Exercises
  module Import
    module Quadbase

      EXERCISES_HOST = 'http://localhost:3000'
      EXERCISES_ATTACHMENTS_URL = "#{EXERCISES_HOST}/attachments"
      EXERCISES_ATTACHMENTS_PATH = 'public/attachments'

      QUADBASE_URL = 'https://quadbase.org'
      QUADBASE_QUESTIONS_URL = "#{QUADBASE_URL}/questions/q"

      ATTACHMENT_EXTENSIONS = ['jpeg', 'jpg', 'png', 'gif', 'pdf']
      FILENAME_EXPRESSION = "[\\w-]+\\.(?:#{ATTACHMENT_EXTENSIONS.join('|')})"
      QUADBASE_ATTACHMENTS_REGEX = Regexp.new "<p><center><img src=\\\"(#{QUADBASE_URL}/system/attachments/[\\d]+/medium/(#{FILENAME_EXPRESSION}))\\\"></center></p>"
      QUADBASE_MATH_REGEX = /\$+[^\$]*\$+/m

      # Returns the license to be applied to quadbase questions
      def default_license
        @@default_license ||= License.find_by(name: 'cc_by_4_0')
      end

      # Gets the contents of the given URL
      def http_get(url)
        Net::HTTP.get(URI.parse(url))
      end

      # Writes a string to a file, erasing the contents and creating it if needed
      def write_to_file(filename, content)
        open(filename, 'wb') do |file|
          file.write(content)
        end
      end

      # Gets a file from a url and saves it locally
      def download_attachment(url, filename)
        Dir.mkdir EXERCISES_ATTACHMENTS_PATH \
          unless File.exists? EXERCISES_ATTACHMENTS_PATH
        destination = "#{EXERCISES_ATTACHMENTS_PATH}/#{filename}"
        write_to_file(destination, http_get(url))
        "#{EXERCISES_ATTACHMENTS_URL}/#{filename}"
      end

      # Converts Quadbase's dollar sign math to a math tag
      def math_tag(math)
        inner_math = math[1..-2]
        tag = 'span'
        if QUADBASE_MATH_REGEX =~ inner_math
          inner_math = inner_math[1..-2]
          tag = 'div'
        end

        "<#{tag} data-math=\"#{inner_math.gsub('"', '&quot;')}\"></#{tag}>"
      end

      # Converts Quadbase HTML to Exercises HTML
      def convert_html(html)
        attachments = html.to_s.scan(QUADBASE_ATTACHMENTS_REGEX)
        attachments.each do |url, filename|
          html = html.gsub(url, download_attachment(url, filename))
        end
        maths = html.scan(QUADBASE_MATH_REGEX)
        maths.each do |math|
          html = html.gsub(math, math_tag(math))
        end
        html
      end

      # Imports a collaborator (requires username, email attributes in the hash)
      # Returns the collaborator
      def import_collaborator(hash, klass)
        username = hash['username']
        return if username.nil?

        account = OpenStax::Accounts::Account.find_by(username: username)
        if account.nil?
          email = hash.delete('email')
          return if email.nil?

          hash.delete('id')
          hash['full_name'] = hash.delete('name')

          #  TODO: Make an API in OpenStax Accounts that finds or creates an Account
          #  for an email address (returns only the openstax_uid, no other info)
          #  Call that API and link the local account to the remote one by ID
          # hash['openstax_uid'] = OpenStax::Accounts.configuration.enable_stubbing? ? -SecureRandom.hex.to_i(16) : \
          #  OpenStax::Accounts.find_or_create_account_by_email(email)
          hash['openstax_uid'] = -SecureRandom.hex(4).to_i(16)/2

          # Create the local Account
          begin
            OpenStax::Accounts.syncing = true
            # Just noticed that syncing in accounts-rails is not thread-safe...
            account = OpenStax::Accounts::Account.create!(hash)
          ensure
            OpenStax::Accounts.syncing = false
          end
        end

        user = User.find_or_create_by(account_id: account.id)

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
        exercise.stimulus = convert_html(hash['html']) unless hash.nil?
        exercise
      end

      # Imports a Quadbase question without the introduction
      # Returns the Question
      def import_without_introduction(hash)
        question = Question.new
        stem = Stem.new(question: question,
                        content: convert_html(hash['content']['html']))

        stem.stylings << Styling.new(stylable: stem,
                                     style: Style::DRAWING) \
          if hash['answer_can_be_sketched']

        if hash['answer_choices']
          stem.stylings << Styling.new(stylable: stem,
                                       style: Style::MULTIPLE_CHOICE)

          hash['answer_choices'].each do |ac|
            answer = Answer.new(question: question,
                                content: convert_html(ac['html']))
            question.answers << answer
            stem.stem_answers << StemAnswer.new(stem: stem, answer: answer,
                                                correctness: ac['credit'])
          end
        else
          stem.stylings << Styling.new(stylable: stem,
                                       style: Style::FREE_RESPONSE)
        end

        question.stems << stem
        question
      end

      # Imports a simple question
      # Returns an Exercise
      def import_simple(hash)
        exercise = import_introduction(hash['introduction'])
        question = import_without_introduction(hash)
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
          question = import_without_introduction(p['simple_question'])
          question.exercise = exercise
          id_map[p['simple_question']['id']] = question
          prerequisites = (p['prerequisites'] || []).collect{|pre| pre['id']}
          supports = (p['supported_by'] || []).collect{|pre| pre['id']}
          dependency_map[question] = {prerequisites: prerequisites,
                                      supports: supports}
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

      # Imports and saves a Quadbase question as an Exercise
      # Returns true if the Exercise was saved or false otherwise
      def import_question(hash)
        if hash['multipart_question']
          hash = hash['multipart_question']
          exercise = import_multipart(hash)
        elsif hash['simple_question']
          hash = hash['simple_question']
          exercise = import_simple(hash)

          # Skip duplicates (to avoid importing the individual
          #                  parts of multipart questions)
          stimulus = ParseContent.call(exercise.stimulus).outputs[:content]
          stem = ParseContent.call(exercise.questions.first.stems.first.content)
                             .outputs[:content]
          return false if Exercise.joins(:questions => :stems)
                                  .where(stimulus: stimulus,
                                         questions: { stems: { content: stem } })
                                  .exists?
        end
        publication = import_metadata(hash['attribution'])
        publication.publishable = exercise
        exercise.publication = publication

        exercise.save
      end

      # Imports Quadbase questions from the given file
      def import_file(filename)
        json = File.open(filename, 'r') { |file| file.read }
        hash = JSON.parse(json)
        questions = hash['questions']
        puts "Importing #{questions.length} exercises"
        questions.each { |q| import_question(q) }
      end

      # Imports a Quadbase question by question ID
      # Returns true if the Exercise was saved or false otherwise
      def remote_import_question(id)
        id = id.to_s
        id[0] = '' if id[0] == 'q'

        url = "#{QUADBASE_QUESTIONS_URL}#{id}.json"
        content = http_get(url)
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

    end
  end
end
