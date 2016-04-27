require 'rails_helper'

RSpec.describe VocabTerms::Import::Xlsx do
  let(:fixture_path) { 'spec/fixtures/sample_vocab_terms.xlsx' }

  let(:expected_los) {
    [
      'lo:stax-prog:1-1-1',
      'lo:stax-prog:1-1-2',
      'lo:stax-prog:1-1-3',
      'lo:stax-prog:1-2-1',
      'lo:stax-prog:1-2-2',
      'lo:stax-prog:1-3-1',
      'lo:stax-prog:1-3-2'
    ]
  }

  let!(:author) { FactoryGirl.create :user }
  let!(:ch)     { FactoryGirl.create :user }

  it 'imports the sample spreadsheet' do
    expect {
      described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
    }.to change{ VocabTerm.count }.by(200)

    imported_vocab_terms = VocabTerm.order(created_at: :desc).limit(200).to_a

    imported_vocab_terms.each do |vocab_term|
      expect(vocab_term.authors.first.user).to eq author
      expect(vocab_term.copyright_holders.first.user).to eq ch

      expect(vocab_term.list_vocab_terms.first.list.name).to eq 'Test'

      expect(vocab_term.tags).not_to be_blank
      tag_names = vocab_term.tags.map(&:name)
      expect((tag_names & expected_los).length).to eq 1

      expect(vocab_term.name).to be_present
      expect(vocab_term.definition).to be_present

      expect(vocab_term.distractors).to be_present
    end
  end

  it 'skips vocab_terms with no changes' do
    expect {
      described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
    }.to change{ VocabTerm.count }.by(200)

    expect {
      described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
    }.not_to change{ VocabTerm.count }
  end
end
