require 'a15k/html_preview'
require 'yaml'

namespace :a15k do
  namespace :export do
    desc "export exercise to a15k"
    task :a15k, [:number] => [:environment] do |t, args|

      format_data = YAML.load_file Rails.root.join('config', 'a15k-format.yml')
      format_api = A15kClient::FormatsApi.new
      format = format_api
                 .get_formats.data
                 .find{|format| format.identifier == format_data['identifier'] }

      if format.nil?
        format = format_api.create_format(format_data).data
      end


      exercise = Exercise.published.with_id(args[:number]).first!

      html = Exercises::HtmlPreview.new(exercise)
      assessments = A15kClient::AssessmentsApi.new

      begin
        reply = assessments.create_assessment(
          identifier: exercise.uuid,
          preview_html: html.generate,
          questions: [
            {
              format_id: format.id,
              content: Api::V1::Exercises::Representer.new(exercise).as_json
            }
          ]
        )

        if reply.success
          puts "Imported with uuid: #{reply.data.id}"
        else
          raise "Failed to create assessment: #{reply.message}"
        end
      rescue A15kClient::ApiError => e


      end
    end
  end
end
