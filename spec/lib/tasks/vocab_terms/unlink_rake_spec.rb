require 'rails_helper'
require 'rake'

RSpec.describe 'vocab_terms unlink', type: :rake do
  before :all do
    Rake.application.rake_require 'tasks/vocab_terms/unlink'
    Rake::Task.define_task(:environment)
  end

  let :run_rake_task do
    Rake::Task['vocab_terms:unlink'].reenable
    Rake.application.invoke_task 'vocab_terms:unlink'
  end

  let!(:linked_vocab_term)   { FactoryGirl.create :vocab_term }
  let!(:unlinked_vocab_term) { FactoryGirl.create :vocab_term, vocab_distractors_count: 0 }

  it 'calls #unlink on all linked vocab_terms' do
    expect(linked_vocab_term.vocab_distractors).not_to be_empty

    original_unlink = VocabTerm.instance_method(:unlink)
    expect_any_instance_of(VocabTerm).to receive(:unlink) do |vocab_term|
      expect(vocab_term).to eq linked_vocab_term

      original_unlink.bind(vocab_term).call
    end

    run_rake_task

    expect(linked_vocab_term.reload.vocab_distractors).to be_empty
  end
end
