module A15k
  class Exporter

    class CreateAssessmentError < StandardError; end

    def initialize
      @outcomes = {
        success_count: 0,
        failure_info: []
      }
    end

    def run
      format = make_sure_format_is_uploaded_and_return

      Exercise.published                     # Select only published exercises
              .can_release_to_a15k           # That have been marked as releaseable to a15k
              .not_released_to_a15k          # And that haven't yet been released
              .find_each do |exercise|

        begin
          export_one_exercise(exercise, format)

          outcomes[:success_count] += 1
        rescue CreateAssessmentError, A15kClient::ApiError => ee
          outcomes[:failure_info].push({uid: exercise.uid, message: ee.message})
        end

      end

      outcomes
    end

    def make_sure_format_is_uploaded_and_return
      # See if it is already uploaded
      format = formats_api.get_formats
                          .data
                          .find{|format| format.identifier == format_data['identifier']}

      # If it is uploaded, return it; otherwise upload it via the API and return it
      format || formats_api.create_format(
                  YAML.load_file Rails.root.join('lib/a15k', 'format.yml') # read from local file
                ).data
    end

    def export_one_exercise(exercise, format)
      # Get the exercise JSON; we toss out "community solutions" for licensing
      # reasons.

      exercise_data = Api::V1::Exercises::Representer.new(exercise).to_h
      exercise_data[:questions].each do |question_data|
        question_data.delete(:community_solutions)
      end

      # Make the API call
      reply = assessments_api.create_assessment(
        source_identifier: exercise.publication_group.uuid,      # the shared UUID among versions
        source_version: exercise.publication.version,            # this version's version number
        variants: [                                              # we don't have generative assessments,
          {                                                      #   so only one 'variant'
            format_id: format.id,
            content: exercise_data.as_json,
            preview_html: A15k::HtmlPreview.new(exercise).generate,
          }
        ]
      )

      raise(CreateAssessmentError, reply.message) if !reply.success

      # Store the A15k identifier and version locally to let us report on them later
      exercise.update_attributes(
        a15k_identifier: reply.data.a15k_identifier,
        a15k_version: reply.data.a15k_version
      )
    end

    def formats_api
      @formats_api ||= A15kClient::FormatsApi.new         # the auto-generated Ruby API client
    end

    def assessments_api
      @assessments_api ||= A15kClient::AssessmentsApi.new # the auto-generated Ruby API client
    end

  end
end
