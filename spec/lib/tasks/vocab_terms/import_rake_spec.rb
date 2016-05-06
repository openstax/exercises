require 'rails_helper'
require 'rake'

describe 'vocab_terms import' do
  before :all do
    Rake.application.rake_require "tasks/vocab_terms/import"
    Rake::Task.define_task(:environment)
  end

  context 'xlsx' do
    let(:fixture_path) { '../spec/fixtures/sample_vocab_terms.xlsx' }

    let :run_rake_task do
      Rake::Task["vocab_terms:import:xlsx"].reenable
      Rake.application.invoke_task "vocab_terms:import:xlsx[#{fixture_path},42,10]"
    end

    it 'passes arguments to VocabTerms::Import::Xlsx' do
      expect(VocabTerms::Import::Xlsx).to(
        receive(:call).with(filename: fixture_path, author_id: '42', ch_id: '10')
      )
      run_rake_task
    end
  end
end
