require 'rails_helper'

RSpec.describe VocabTerms::Import::Xlsx, type: :routine do
  let(:fixture_path) { 'spec/fixtures/sample_vocab_terms.xlsx' }

  let(:expected_names) {
    ['assembly', 'c', 'python', 'ruby', 'rails', 'django', 'tutor-server', 'tutor-js']
  }

  let(:expected_definitions) {
    [
      'lowest level programming language',
      'most widely used low level programming language',
      'most popular high level programming language',
      'programming language used for the majority of this repository',
      'ruby framework for creating websites',
      'python CMS framework',
      'the backend of OpenStax Tutor',
      'the frontend of OpenStax Tutor'
    ]
  }

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

  let(:author) { FactoryBot.create :user }
  let(:ch)     { FactoryBot.create :user }

  before { VocabTerms::Importer::BOOK_NAMES.merge!('Introduction to Programming' => 'prog') }

  it 'imports the sample spreadsheet' do
    expect {
      described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
    }.to change{ VocabTerm.count }.by(8)

    imported_vocab_terms = VocabTerm.order(created_at: :desc).limit(8).to_a

    imported_vocab_terms.each do |vocab_term|
      expect(vocab_term).to be_is_published

      expect(vocab_term.authors.first.user).to eq author
      expect(vocab_term.copyright_holders.first.user).to eq ch

      list = vocab_term.publication.publication_group.list_publication_groups.first.list
      expect(list.name).to eq 'Introduction to programming Chapter 1'

      expect(vocab_term.tags).not_to be_blank
      tag_names = vocab_term.tags.map(&:name)
      expect((tag_names & expected_los).size).to eq 1

      expect(expected_names).to include(vocab_term.name)
      expect(expected_definitions).to include(vocab_term.definition)

      expect(vocab_term.distractors.size).to eq 4
    end
  end

  it 'skips vocab_terms with no changes' do
    expect {
      described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
    }.to change{ VocabTerm.count }.by(8)

    expect {
      described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
    }.not_to change{ VocabTerm.count }
  end
end
