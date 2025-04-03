require 'rails_helper'
require 'vcr_helper'

RSpec.describe Exercises::Import::Assessments, type: :routine, vcr: VCR_OPTS do
  let(:book_uuid)    { '62a49025-8cd8-407c-9cfb-c7eba55cf1c6' }
  let(:fixture_path) { 'spec/fixtures/sample_import_assessments.xlsx' }

  before(:all) do
    DatabaseCleaner.start

    2.times { FactoryBot.create :user, :agreed_to_terms }
  end
  after(:all)  { DatabaseCleaner.clean }

  it 'imports exercises from the spreadsheet and adds Assignable tags' do
    author = User.find(1)
    copyright_holder = User.find(2)

    allow_any_instance_of(OpenStax::Content::Book).to receive(:version).and_return('964da1b')

    expect { described_class.call(book_uuid: book_uuid, filename: fixture_path) }.to change { Exercise.count }.by(2)

    exercises = Exercise.order(:created_at).last(2)

    expect(Set.new exercises[0].tags.map(&:to_s)).to eq Set[
      'assessment:preparedness:https://openstax.org/orn/book:page/62a49025-8cd8-407c-9cfb-c7eba55cf1c6:97af6b57-0004-4218-99c1-f2cfedea8f30',
      'context-cnxmod:97af6b57-0004-4218-99c1-f2cfedea8f30',
      'book-slug:college-success-concise',
      'book-slug:preparing-for-college-success',
      'module-slug:college-success-concise:1-1-why-college',
      'module-slug:preparing-for-college-success:2-1-why-college',
    ]
    expect(exercises[0].questions.first.stems.first.content).to eq 'Some question?'
    expect(Set.new(exercises[0].questions.first.stems.first.stem_answers.map do |stem_answer|
      [stem_answer.answer.content, stem_answer.correctness.to_s, stem_answer.feedback]
    end)).to eq Set[['Right', '1.0', 'This is why A is correct'], ['Wrong', '0.0', 'This is why B is wrong']]
    expect(exercises[0].questions.first.collaborator_solutions.first.content).to eq 'Some solution'

    expect(Set.new exercises[1].tags.map(&:to_s)).to eq Set[
      'assessment:practice:https://openstax.org/orn/book:page/62a49025-8cd8-407c-9cfb-c7eba55cf1c6:6c30d0cc-e435-4081-be68-5ff2f558cbec',
      'context-cnxmod:6c30d0cc-e435-4081-be68-5ff2f558cbec',
      'book-slug:college-success',
      'module-slug:college-success:1-2-the-first-year-of-college-will-be-an-experience',
    ]
    expect(exercises[1].questions.first.stems.first.content).to eq 'Another question?'
    expect(Set.new(exercises[1].questions.first.stems.first.stem_answers.map do |stem_answer|
      [stem_answer.answer.content, stem_answer.correctness.to_s, stem_answer.feedback]
    end)).to eq Set[['Not this one', '0.0', 'Better luck next time'], ['This one', '1.0', 'Good job']]
    expect(exercises[1].questions.first.collaborator_solutions.first.content).to eq 'Another solution'
  end
end
