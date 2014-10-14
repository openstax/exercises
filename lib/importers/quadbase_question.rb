module Importers
  module QuadbaseQuestion
    BASE_URL = 'https://www.quadbase.org/questions/q'
    DRAWING_FORMAT = Format.find_by(name: 'drawing')

    def self.import_simple(hash)
      question = Question.new(stem: hash['content']['html'])
      question.formattings < Formatting.new(formattable: question,
                                            format: DRAWING_FORMAT)
      exercise = Exercise.new()
    end

    def self.import_multipart(hash)
    end

    def self.import_json(json)
      hash = JSON.parse(json)
      import_simple(hash['simple_question']) if hash['simple_question']
      import_multipart(hash['multipart_question']) if hash['multipart_question']
    end

    def self.remote_import(id)
      id = id.to_s
      id[0] = '' if id[0] == 'q'

      url = "#{BASE_URL}#{id}.json"
      content = Net::HTTP.get(URI.parse(url))
      import_json(content)
    end
  end
end
