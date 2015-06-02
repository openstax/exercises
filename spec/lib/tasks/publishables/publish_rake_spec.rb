require 'rails_helper'
require 'rake'

describe 'publishables publish' do
  before :all do
    Rake.application.rake_require "tasks/publishables/publish"
    Rake::Task.define_task(:environment)
  end

  context 'all' do
    let :run_rake_task do
      Rake::Task["publishables:publish:all"].reenable
      Rake.application.invoke_task "publishables:publish:all"
    end

    it 'calls Publishables::Publish::All' do
      expect(Publishables::Publish::All).to receive(:call)
      run_rake_task
    end
  end
end
