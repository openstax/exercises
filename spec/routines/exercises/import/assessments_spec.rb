require 'rails_helper'
require 'vcr_helper'

RSpec.describe Exercises::Import::Assessments, type: :routine, vcr: VCR_OPTS do
  let(:archive)      { OpenStax::Content::Archive.new(version: '20250226.165223') }
  let(:book_uuid)    { '62a49025-8cd8-407c-9cfb-c7eba55cf1c6' }
  let(:fixture_path) { 'spec/fixtures/sample_import_assessments.xlsx' }

  before do
    allow_any_instance_of(OpenStax::Content::Abl).to receive(:books).and_return([
      OpenStax::Content::Book.new(
        archive: archive,
        uuid: 'e8668a14-9a7d-4d74-b58c-3681f8351224',
        version: '964da1b',
        slug: 'college-success'
      ),
      OpenStax::Content::Book.new(
        archive: archive,
        uuid: '62a49025-8cd8-407c-9cfb-c7eba55cf1c6',
        version: '964da1b',
        slug: 'college-success-concise'
      )
    ])
  end

  it 'imports exercises from the spreadsheet and adds Assignable tags' do
    allow(User).to receive(:find) { FactoryBot.create :user, :agreed_to_terms }

    allow_any_instance_of(OpenStax::Content::Book).to receive(:version).and_return('964da1b')

    expect { described_class.call(book_uuid: book_uuid, filename: fixture_path) }.to change { Exercise.count }.by(3)

    exercises = Exercise.order(:created_at).last(3)

    expect(exercises[0].publication_group.nickname).to eq 'Q1'
    expect(Set.new exercises[0].tags.map(&:to_s)).to eq Set[
      'assessment:preparedness:https://openstax.org/orn/book:page/62a49025-8cd8-407c-9cfb-c7eba55cf1c6:97af6b57-0004-4218-99c1-f2cfedea8f30',
      'machine-teks:dacf53a6-2b09-49f1-9926-de4efe1049e0',
      'teks:T1.1',
    ]
    expect(exercises[0].questions.first.stems.first.content).to eq 'Some question?'
    expect(Set.new(exercises[0].questions.first.stems.first.stem_answers.map do |stem_answer|
      [stem_answer.answer.content, stem_answer.correctness.to_s, stem_answer.feedback]
    end)).to eq Set[['Right', '1.0', 'This is why A is correct'], ['Wrong', '0.0', 'This is why B is wrong']]
    expect(exercises[0].questions.first.collaborator_solutions.first.content).to eq 'Some solution'
    expect(exercises[0].publication.published_at?).to eq true

    expect(exercises[1].publication_group.nickname).to eq 'Q2'
    expect(Set.new exercises[1].tags.map(&:to_s)).to eq Set[
      'assessment:practice:https://openstax.org/orn/ancillary/e9779614-2fca-43cb-ae53-4af6d20e00ea',
      'assessment:practice:https://openstax.org/orn/book:page/62a49025-8cd8-407c-9cfb-c7eba55cf1c6:6c30d0cc-e435-4081-be68-5ff2f558cbec',
      'context-cnxmod:6c30d0cc-e435-4081-be68-5ff2f558cbec',
      'book-slug:college-success',
      'machine-teks:c6623b8d-1eb7-41bf-875b-3456036000f9',
      'module-slug:college-success:1-2-the-first-year-of-college-will-be-an-experience',
      'teks:T1.2',
    ]
    expect(exercises[1].questions.first.stems.first.content).to eq(
      'Another question with <span data-math="R = a^i/se">R = a^i/se</span> math?'
    )
    expect(Set.new(exercises[1].questions.first.stems.first.stem_answers.map do |stem_answer|
      [stem_answer.answer.content, stem_answer.correctness.to_s, stem_answer.feedback]
    end)).to eq Set[['Not this one', '0.0', 'Better luck next time'], ['This one', '1.0', 'Good job']]
    expect(exercises[1].questions.first.collaborator_solutions.first.content).to eq 'Another solution'
    expect(exercises[1].publication.published_at?).to eq true

    expect(exercises[2].publication_group.nickname).to eq 'Q3'
    expect(Set.new exercises[2].tags.map(&:to_s)).to eq Set[
      'machine-teks:e6beb10a-f5cd-4b18-bf4a-e2f7174779bd',
      'teks:T1.3',
    ]
    expect(exercises[2].stimulus).to eq 'Oh look, multipart!'
    expect(exercises[2].questions.first.stems.first.content).to eq('First part?')
    expect(exercises[2].questions.first.stems.first.stem_answers).to eq []
    expect(exercises[2].questions.first.collaborator_solutions).to eq []
    expect(exercises[2].questions.second.stems.first.content).to eq('Second part?')
    expect(exercises[2].questions.second.stems.first.stem_answers).to eq []
    expect(exercises[2].questions.second.collaborator_solutions).to eq []
    expect(exercises[2].publication.published_at?).to eq true
  end
end
