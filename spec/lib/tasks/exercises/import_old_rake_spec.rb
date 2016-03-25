require 'rails_helper'
require 'rake'

describe 'exercises import old' do
  before :all do
    Rake.application.rake_require "tasks/exercises/import_old"
    Rake::Task.define_task(:environment)
  end

  context 'xlsx' do
    let(:fixture_path) { '../spec/fixtures/old/sample_exercises.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:import:old:xlsx"].reenable
      Rake.application.invoke_task "exercises:import:old:xlsx[#{fixture_path},42,10]"
    end

    it 'passes arguments to Exercises::Import::Old::Xlsx' do
      expect(Exercises::Import::Old::Xlsx).to(
        receive(:call).with(filename: fixture_path, author_id: '42', ch_id: '10')
      )
      run_rake_task
    end
  end

  context 'zip' do
    let(:fixture_path) { '../spec/fixtures/old/sample_exercises.zip' }

    let :run_rake_task do
      Rake::Task["exercises:import:old:zip"].reenable
      Rake.application.invoke_task "exercises:import:old:zip[#{fixture_path},42,10]"
    end

    it 'passes arguments to Exercises::Import::Old::Zip' do
      expect(Exercises::Import::Old::Zip).to(
        receive(:call).with(filename: fixture_path, author_id: '42', ch_id: '10')
      )
      run_rake_task
    end
  end
end
