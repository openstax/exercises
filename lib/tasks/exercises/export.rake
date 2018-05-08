namespace :exercises do
  namespace :export do
    desc "export exercises to a15k"
    task :a15k => :environment do |t, args|

      A15kClient.configure do |c|
        c.host = 'localhost:4001'
        c.scheme = 'http'
        # c.debugging = true
        c.api_key['Authorization'] = ENV['A15K_AUTH']
        c.verify_ssl_host = false
        c.api_key_prefix['Authorization'] = 'Bearer'
      end

      api_instance = A15kClient::AssessmentsApi.new

      exercise = Api::V1::Exercises::Representer.new(Exercise.find(30150)).as_json
      questions = exercise.delete('questions')

      ox_format_uuid = "7ec91a74-ff17-4460-9776-1f2fc6b9ce61"

      api_instance.api_v1_assessments_json_post(
        data: {
          type: 'assessment',
          attributes: {
            format_id: ox_format_uuid,
            content: JSON.generate(exercise)
          },
          relationships: {
            questions: {
              data: questions.map{|question|
                answers = question.delete('answers')
                {
                  type: 'question',
                  attributes: {
                    format_id: ox_format_uuid,
                    content: JSON.generate(question)
                  },
                  relationships: {
                    solutions: {
                      data: answers.map{|answer|
                        {
                          type: 'solution',
                          attributes: {
                            format_id: ox_format_uuid,
                            content: JSON.generate(answer)
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      )
    end
  end
end
