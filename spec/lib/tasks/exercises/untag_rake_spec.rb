require 'rails_helper'
require 'rake'

RSpec.describe 'exercises untag', type: :rake do
  before :all do
    Rake.application.rake_require "tasks/exercises/untag"
    Rake::Task.define_task(:environment)
  end

  context 'xlsx' do
    let(:fixture_path) { '../spec/fixtures/sample_tags.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:untag:xlsx"].reenable
      Rake.application.invoke_task "exercises:untag:xlsx[#{fixture_path}]"
    end

    it 'passes arguments to Exercises::Untag::Xlsx' do
      expect(Exercises::Untag::Xlsx).to(
        receive(:call).with(filename: fixture_path)
      )
      run_rake_task
    end
  end
end
