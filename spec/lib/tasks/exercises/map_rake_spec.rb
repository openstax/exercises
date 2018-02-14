require 'rails_helper'
require 'rake'

RSpec.describe 'exercises map', type: :rake do
  before :all do
    Rake.application.rake_require "tasks/exercises/map"
    Rake::Task.define_task(:environment)
  end

  context 'xlsx' do
    let(:fixture_path) { '../spec/fixtures/sample_map.xlsx' }

    let :run_rake_task do
      Rake::Task["exercises:map:xlsx"].reenable
      Rake.application.invoke_task "exercises:map:xlsx[#{fixture_path}]"
    end

    it 'passes arguments to Exercises::Map::Xlsx' do
      expect(Exercises::Map::Xlsx).to(
        receive(:call).with(filename: fixture_path)
      )
      run_rake_task
    end
  end
end
