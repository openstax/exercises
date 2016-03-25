require 'rails_helper'
require 'rake'

describe 'exercises import' do
  before :all do
    Rake.application.rake_require "tasks/exercises/import"
    Rake::Task.define_task(:environment)
  end

  context 'excel' do
    let(:fixture_path) { '../spec/fixtures/sample_exercises.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:import:xlsx"].reenable
      Rake.application.invoke_task "exercises:import:xlsx[#{fixture_path},42,10]"
    end

    it 'passes arguments to Exercises::Import::Xlsx' do
      expect(Exercises::Import::Xlsx).to(
        receive(:call).with(filename: fixture_path, author_id: '42', ch_id: '10')
      )
      run_rake_task
    end
  end

  context 'zip' do
    let(:fixture_path) { '../spec/fixtures/sample_exercises.zip' }

    let :run_rake_task do
      Rake::Task["exercises:import:zip"].reenable
      Rake.application.invoke_task "exercises:import:zip[#{fixture_path},42,10]"
    end

    it 'passes arguments to Exercises::Import::Zip' do
      expect(Exercises::Import::Zip).to(
        receive(:call).with(filename: fixture_path,
                            author_id: '42',
                            ch_id: '10')
      )
      run_rake_task
    end
  end
end
