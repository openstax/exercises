require 'rails_helper'
require 'rake'

RSpec.describe 'exercises export to a15k', type: :rake do

  before :all do
    Rake.application.rake_require "tasks/a15k/export"
    Rake::Task.define_task(:environment)
  end

  let(:exercise) { FactoryBot.create :exercise, :published, release_to_a15k: true }

  context 'a15k' do

    let :run_rake_task do
      capture_stdout {
        Rake::Task["a15k:export"].reenable
        Rake.application.invoke_task "a15k:export"
      }
    end

    it 'calls AssessmentsApi to create an assessment' do
      format_data = OpenStruct.new(id: 1234)
      def format_data.find
        self
      end
      formats_api = OpenStruct.new(data: format_data)

      expect_any_instance_of(A15kClient::FormatsApi).to(
        receive(:get_formats).and_return(formats_api)

      )

      assessments_api = Hashie::Mash.new(success: true, data: { id: 1234 })

      expect_any_instance_of(A15kClient::AssessmentsApi).to(
        receive(:create_assessment)
          .with(
            hash_including(
              source_identifier: exercise.publication_group.uuid
            )
          )
          .and_return(assessments_api)
      )

      run_rake_task
    end
  end

end
