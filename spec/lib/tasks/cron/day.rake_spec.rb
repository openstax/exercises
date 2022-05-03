require 'rails_helper'
require 'rake'

RSpec.describe 'cron:day', type: :rake do
  before :all do
    Rake.application.rake_require 'tasks/cron/day'
    Rake::Task.define_task :log_to_stdout
  end

  before { Rake::Task['cron:day'].reenable }

  it 'calls the UpdateSlugs and WarmUpCache lev routines' do
    expect(UpdateSlugs).to receive(:call)
    expect(WarmUpCache).to receive(:call)

    Rake.application.invoke_task 'cron:day'
  end
end
