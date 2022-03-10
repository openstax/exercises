require 'rails_helper'
require 'rake'

RSpec.describe 'cron:minute', type: :rake do
  before :all do
    Rake.application.rake_require 'tasks/cron/minute'
    Rake::Task.define_task :log_to_stdout
  end

  before { Rake::Task['cron:minute'].reenable }

  let!(:task) { instance_double(Rake::Task) }

  it 'calls the openstax:accounts:sync rake task' do
    expect(Rake::Task).to receive(:[]).with('openstax:accounts:sync:accounts').and_return(task)
    expect(task).to receive(:invoke)

    Rake.application.invoke_task 'cron:minute'
  end
end
