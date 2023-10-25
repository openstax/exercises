require 'rails_helper'
require 'rake'

RSpec.describe 'exercises tag', type: :rake do
  before :all do
    Rake.application.rake_require "tasks/exercises/tag"
    Rake::Task.define_task(:environment)
  end

  context 'import_from_module_map' do
    let(:fixture_path) { './spec/fixtures/sample_module_map.csv' }

    let :run_rake_task do
      Rake::Task["exercises:tag:import_from_module_map"].reenable
      Rake.application.invoke_task "exercises:tag:import_from_module_map[#{fixture_path}]"
    end

    it 'adds additional tags' do
      exercise = FactoryBot.create :exercise
      exercise.exercise_tags << FactoryBot.create(:exercise_tag, tag: FactoryBot.create(:tag, name: "context-cnxmod:c6b53107-4efb-48a9-8ccf-4db622f029f3"))
      expect{
        run_rake_task
      }.to change{ exercise.tags.reload.count }.by(1)
      # adds the matching tag
      expect(exercise.tags.where(name:"context-cnxmod:ea90794e-0043-4160-a494-3f370885c7e3")).to exist
      # skips tag that wasn't found
      expect(exercise.tags.where(name:"context-cnxmod:2f8a5d38-00d5-4c53-8df5-01294fb5a764")).not_to exist
    end
  end

  context 'spreadsheet' do
    let(:fixture_path) { '../spec/fixtures/sample_tags.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:tag:spreadsheet"].reenable
      Rake.application.invoke_task "exercises:tag:spreadsheet[#{fixture_path}]"
    end

    it 'passes arguments to Exercises::Tag::Spreadsheet' do
      expect(Exercises::Tag::Spreadsheet).to(
        receive(:call).with(filename: fixture_path)
      )
      run_rake_task
    end
  end

  context 'assessments' do
    let(:fixture_path) { '../spec/fixtures/sample_assessment_tags.xlsx' }
    let(:book_uuid)    { SecureRandom.uuid }

    let :run_rake_task do
      Rake::Task["exercises:tag:assessments"].reenable
      Rake.application.invoke_task "exercises:tag:assessments[#{fixture_path},#{book_uuid}]"
    end

    it 'passes arguments to Exercises::Tag::Assessments' do
      expect(Exercises::Tag::Assessments).to(
        receive(:call).with(filename: fixture_path, book_uuid: book_uuid)
      )
      run_rake_task
    end
  end
end
