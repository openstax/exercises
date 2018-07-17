require 'rails_helper'
require 'rake'

RSpec.describe 'exercises export', type: :rake do

  before :all do
    Rake.application.rake_require "tasks/exercises/export"
    Rake::Task.define_task(:environment)
  end

  let(:exercise) { FactoryBot.create :exercise, :published }

  context 'a15k' do


    let :run_rake_task do
      Rake::Task["exercises:export:a15k"].reenable
      Rake.application.invoke_task "exercises:export:a15k[#{exercise.number}]"
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
              identifier: exercise.uuid,
            )
          )
          .and_return(assessments_api)
      )

      run_rake_task
    end
  end

end
