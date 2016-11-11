require 'rails_helper'
require 'rake'

RSpec.describe 'exercises import', type: :rake do
  before :all do
    Rake.application.rake_require "tasks/exercises/import"
    Rake::Task.define_task(:environment)
  end

  context 'xlsx' do
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
        receive(:call).with(filename: fixture_path, author_id: '42', ch_id: '10')
      )
      run_rake_task
    end
  end

  context 'qb' do
    let(:fixture_path) { '../spec/fixtures/quadbase.json' }
    let(:archive_url)  { 'https://archive.cnx.org/contents/031da8d3-b525-429c-80cf-6c8ed997733a' }

    let :run_rake_task do
      Rake::Task["exercises:import:qb"].reenable
      Rake.application.invoke_task "exercises:import:qb[#{fixture_path},physics,#{archive_url}]"
    end

    it 'passes arguments to Exercises::Import::Quadbase' do
      expect(Exercises::Import::Quadbase).to(
        receive(:call).with(filename: fixture_path,
                            book_name: 'physics',
                            book_archive_url: archive_url)
      )
      run_rake_task
    end
  end
end
