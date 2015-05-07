require 'rails_helper'
require 'rake'

describe 'exercises import' do
  before :all do
    Rake.application.rake_require "tasks/exercises_import"
    Rake::Task.define_task(:environment)
  end

  context 'excel' do
    let(:fixture_path) { '../spec/fixtures/sample_exercises.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:import:excel"].reenable
      Rake.application.invoke_task "exercises:import:excel[#{fixture_path},42,10]"
    end

    it 'passes arguments to Exercises::Import::Unicode' do
      expect(Exercises::Import::Excel).to(
        receive(:call).with(filename: fixture_path, author_id: '42', ch_id: '10')
      )
      run_rake_task
    end
  end
end
