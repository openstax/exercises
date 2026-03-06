require 'rails_helper'

RSpec.describe Exercises::Import::WrittenResponse, type: :routine do
  let(:book_uuid)    { SecureRandom.uuid }
  let(:fixture_path) { 'spec/fixtures/sample_import_wrq.xlsx' }
  let(:page_uuid)    { '6b17f8a5-2864-40cc-b599-dfba5930ead2' }

  before do
    allow(User).to receive(:find) { FactoryBot.create :user, :agreed_to_terms }
  end

  # Disable set_slug_tags!
  before { allow_any_instance_of(Exercise).to receive(:set_slug_tags!) }

  it 'imports exercises from the spreadsheet and adds WRQ tags' do
    expect { described_class.call(book_uuid: book_uuid, filename: fixture_path) }.to(
      change { Exercise.count }.by(5)
    )

    exercises = Exercise.order(:created_at).last(5)

    orn             = "https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}"
    expected_cnxmod = "context-cnxmod:#{page_uuid}"
    expected_wr     = "written-response:practice:#{orn}"
    expected_size   = 'response-size:medium'

    # Rows 1–3 have detailed solutions; rows 4–5 do not
    exercises.first(3).each do |exercise|
      expect(exercise.questions.first.stems.first.content).not_to be_blank
      expect(exercise.questions.first.stems.first.stylings.map(&:style)).to eq [Style::FREE_RESPONSE]
      expect(exercise.questions.first.collaborator_solutions.first&.content).not_to be_blank
      expect(Set.new exercise.tags.map(&:to_s)).to include(expected_cnxmod, expected_wr, expected_size)
      expect(exercise.publication.published_at?).to eq true
    end

    exercises.last(2).each do |exercise|
      expect(exercise.questions.first.stems.first.content).not_to be_blank
      expect(exercise.questions.first.stems.first.stylings.map(&:style)).to eq [Style::FREE_RESPONSE]
      expect(exercise.questions.first.collaborator_solutions).to be_empty
      expect(Set.new exercise.tags.map(&:to_s)).to include(expected_cnxmod, expected_wr, expected_size)
      expect(exercise.publication.published_at?).to eq true
    end
  end
end
