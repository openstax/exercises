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

  let!(:published_unlinked_vocab_term) do
    FactoryBot.create :vocab_term, :published, vocab_distractors_count: 0,
                                               distractor_literals: ['test']
  end
  let!(:draft_unlinked_vocab_term) do
    published_unlinked_vocab_term.new_version.tap(&:save!)
  end

  context 'for linked vocab terms' do
    let!(:published_linked_vocab_term) { FactoryBot.create :vocab_term, :published }

    context 'where the latest version is a draft' do
      let!(:draft_linked_vocab_term) do
        published_linked_vocab_term.new_version.tap(&:save!)
      end

      it 'calls #unlink on the latest version draft of the linked vocab_term' do
        expect(draft_linked_vocab_term.vocab_distractors).not_to be_empty
        expect(draft_linked_vocab_term.distractor_literals).to be_empty

        original_unlink = VocabTerm.instance_method(:unlink)
        expect_any_instance_of(VocabTerm).to receive(:unlink) do |vocab_term|
          expect(vocab_term).to eq draft_linked_vocab_term

          original_unlink.bind(vocab_term).call
        end

        run_rake_task

        expect(draft_linked_vocab_term.reload.vocab_distractors).to be_empty
        expect(draft_linked_vocab_term.distractor_literals).not_to be_empty
      end
    end

    context 'where the latest version is not a draft' do
      it 'calls #unlink on a new draft for the linked vocab_term' do
        expect(published_linked_vocab_term.vocab_distractors).not_to be_empty
        expect(published_linked_vocab_term.distractor_literals).to be_empty

        original_unlink = VocabTerm.instance_method(:unlink)
        expect_any_instance_of(VocabTerm).to receive(:unlink) do |vocab_term|
          expect(vocab_term.number).to eq published_linked_vocab_term.number
          expect(vocab_term.version).to be_nil

          original_unlink.bind(vocab_term).call
        end

        expect{ run_rake_task }.to change { VocabTerm.count }.by(1)

        expect(published_linked_vocab_term.reload.vocab_distractors).not_to be_empty
        expect(published_linked_vocab_term.distractor_literals).to be_empty

        new_vocab_term = VocabTerm.order(:created_at).last

        expect(new_vocab_term.vocab_distractors).to be_empty
        expect(new_vocab_term.distractor_literals).not_to be_empty
      end
    end
  end
end
