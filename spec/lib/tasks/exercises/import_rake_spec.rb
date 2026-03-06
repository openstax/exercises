require 'rails_helper'
require 'rake'

RSpec.describe 'exercises import', type: :rake do
  before :all do
    Rake.application.rake_require "tasks/exercises/import"
    Rake::Task.define_task(:environment)
  end

  context 'assessments' do
    let(:fixture_path) { '../spec/fixtures/sample_import_assessments.xlsx' }
    let(:book_uuid)    { SecureRandom.uuid }

    let :run_rake_task do
      Rake::Task["exercises:import:assessments"].reenable
      Rake.application.invoke_task "exercises:import:assessments[#{fixture_path},#{book_uuid}]"
    end

    it 'passes arguments to Exercises::Import::Assessments' do
      expect(Exercises::Import::Assessments).to(
        receive(:call).with(filename: fixture_path, book_uuid: book_uuid)
      )
      run_rake_task
    end
  end

  context 'wrq' do
    let(:fixture_path) { '../spec/fixtures/sample_import_wrq.xlsx' }
    let(:book_uuid)    { SecureRandom.uuid }

    let :run_rake_task do
      Rake::Task["exercises:import:wrq"].reenable
      Rake.application.invoke_task "exercises:import:wrq[#{fixture_path},#{book_uuid}]"
    end

    it 'passes arguments to Exercises::Import::WrittenResponse' do
      expect(Exercises::Import::WrittenResponse).to(
        receive(:call).with(filename: fixture_path, book_uuid: book_uuid)
      )
      run_rake_task
    end
  end
end
