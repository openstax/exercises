require_relative '../../exercises/html_preview'

namespace :exercises do
  namespace :export do
    desc "export exercise to a15k"
    task :a15k, [:id] => [:environment] do |t, args|

      format = A15kClient::FormatsApi.new
                 .get_formats.data
                 .find{|format| format.name == 'OpenStax' }

      raise "Can't find OpenStax format!" unless format

      exercise = Exercise.published.with_id(args[:id]).first
      #(30150)
      html = Exercises::HtmlPreview.new(exercise)

      assessments = A15kClient::AssessmentsApi.new
      reply = assessments.create_assessment(
        format_id: format.id,
        identifier: exercise.uuid,
        preview_html: html.generate,
        questions: [
          {
            format_id: format.id,
            content: Api::V1::Exercises::Representer.new(exercise).as_json
          }
        ]
      )
      p reply.data
      if reply.success
        puts "Imported with uuid: #{reply.data.id}"
      else
        raise "Failed to create assessment: #{reply.message}"
      end
    end
  end
end
