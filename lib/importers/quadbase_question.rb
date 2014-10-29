module Importers
  module QuadbaseQuestion

    EXERCISES_HOST = 'http://localhost:3000'
    EXERCISES_ATTACHMENTS_URL = "#{EXERCISES_HOST}/attachments"
    EXERCISES_ATTACHMENTS_PATH = 'public/attachments'

    QUADBASE_URL = 'https://quadbase.org'
    QUADBASE_QUESTIONS_URL = "#{QUADBASE_URL}/questions/q"

    ATTACHMENT_EXTENSIONS = ['jpeg', 'jpg', 'png', 'gif', 'pdf']
    FILENAME_EXPRESSION = "[\\w-]+\\.(?:#{ATTACHMENT_EXTENSIONS.join('|')})"
    QUADBASE_ATTACHMENTS_REGEX = Regexp.new "<p><center><img src=\\\"(#{QUADBASE_URL}/system/attachments/[\\d]+/medium/(#{FILENAME_EXPRESSION}))\\\"></center></p>"

    # Returns the license to be applied to quadbase questions
    def self.default_license
      @@default_license ||= License.find_by(name: 'cc_by_4_0')
    end

    # Gets the contents of the given URL
    def self.http_get(url)
      Net::HTTP.get(URI.parse(url))
    end

    # Writes a string to a file, erasing the contents and creating it if needed
    def self.write_to_file(filename, content)
      open(filename, 'wb') do |file|
        file.write(content)
      end
    end

    # Gets a file from a url and saves it locally
    def self.download_attachment(url, filename)
      destination = "#{EXERCISES_ATTACHMENTS_PATH}/#{filename}"
      write_to_file(destination, http_get(url))
      "#{EXERCISES_ATTACHMENTS_URL}/#{filename}"
    end

    # Converts Quadbase HTML to Exercises HTML
    def self.convert_html(html)
      attachments = html.to_s.scan(QUADBASE_ATTACHMENTS_REGEX)
      attachments.each do |url, filename|
        html = html.gsub(url, download_attachment(url, filename))
      end
      html
    end

    # Imports a collaborator (requires username, email attributes in the hash)
    # Returns the collaborator
    def self.import_collaborator(hash, klass)
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
        hash['openstax_uid'] = -SecureRandom.hex.to_i(16)

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
    def self.import_metadata(hash)
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

    # Imports a simple question
    # Returns a Question
    def self.import_simple(hash)
      question = Question.new(stem: convert_html(hash['content']['html']))
      question.stylings << Styling.new(stylable: question,
                                       style: Style::DRAWING) \
        if hash['answer_can_be_sketched']

      if hash['answer_choices']
        question.stylings << Styling.new(stylable: question,
                                         style: Style::MULTIPLE_CHOICE)

        hash['answer_choices'].each do |ac|
          question.answers << Answer.new(content: convert_html(ac['html']),
                                         correctness: ac['credit'])
        end
      else
        question.stylings << Styling.new(stylable: question,
                                         style: Style::FREE_RESPONSE)
      end

      question
    end

    # Imports a multipart question
    # Returns a Part
    def self.import_multipart(hash)
      part = Part.new
      part.background = convert_html(hash['introduction']['html']) \
        unless hash['introduction'].nil?
      id_map = {}
      dependency_map = {}

      # First construct all question objects and the maps
      hash['parts'].each do |p|
        question = import_simple(p['simple_question'])
        id_map[p['simple_question']['id']] = question
        prerequisites = (p['prerequisites'] || []).collect{|pre| pre['id']}
        supports = (p['supported_by'] || []).collect{|pre| pre['id']}
        dependency_map[question] = {prerequisites: prerequisites,
                                    supports: supports}
        part.questions << question
        part
      end

      # Then assign question dependencies
      dependency_map.each do |question, ds|
        ds[:prerequisites].each do |d|
          pq = id_map.delete(d)
          next if pq.nil?
          dependency = QuestionDependency.new(parent_question: pq,
                                              is_optional: false)
          question.parent_dependencies << dependency
        end

        ds[:supports].each do |d|
          pq = id_map.delete(d)
          next if pq.nil?
          dependency = QuestionDependency.new(parent_question: pq,
                                              is_optional: true)
          question.parent_dependencies << dependency
        end
      end

      part
    end

    # Imports and saves an Exercise
    # Returns true if the Exercise was saved or false otherwise
    def self.import_exercise(hash)
      exercise = Exercise.new

      if hash['multipart_question']
        hash = hash['multipart_question']
        exercise.parts << import_multipart(hash)
      elsif hash['simple_question']
        hash = hash['simple_question']
        # Skip simple questions with a setup (these belong to a multipart)
        return false unless hash['introduction'].try(:[], 'html').blank?
        part = Part.new
        part.questions << import_simple(hash)
        exercise.parts << part
      end
      exercise.publication = import_metadata(hash['attribution'])

      exercise.save
    end

    # Imports Quadbase exercises from the given file
    def self.import_file(filename)
      json = File.open(filename, 'r') { |file| file.read }
      hash = JSON.parse(json)
      questions = hash['questions']
      puts "Importing #{questions.length} exercises"
      questions.each { |q| import_exercise(q) }
    end

    # Imports an Exercise from Quadbase by Question ID
    # Returns true if the Exercise was saved or false otherwise
    def self.remote_import_exercise(id)
      id = id.to_s
      id[0] = '' if id[0] == 'q'

      url = "#{QUADBASE_QUESTIONS_URL}#{id}.json"
      content = http_get(url)
      return false if content.blank?

      import_exercise(JSON.parse(content))
    end

    # Imports all Quadbase questions in the given ID range
    def self.remote_import_range(id_range)
      puts 'Importing...'
      for id in id_range
        puts "Question q#{id}"
        remote_import_exercise(id)
      end
      puts 'Done.'
    end
  end
end
