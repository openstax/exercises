require 'rails_helper'
require 'rake'

describe 'exercises import old' do
  before :all do
    Rake.application.rake_require "tasks/exercises/old/import"
    Rake::Task.define_task(:environment)
  end

  context 'excel' do
    let(:fixture_path) { '../spec/fixtures/old/sample_exercises.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:import:old:excel"].reenable
      Rake.application.invoke_task "exercises:import:old:excel[#{fixture_path},42,10]"
    end

    it 'passes arguments to Exercises::Import::Old::Excel' do
      expect(Exercises::Import::Old::Excel).to(
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
        receive(:call).with(filename: fixture_path,
                            author_id: '42',
                            ch_id: '10')
      )
      run_rake_task
    end
  end
end
