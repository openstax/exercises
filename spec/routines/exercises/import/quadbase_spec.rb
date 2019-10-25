require 'rails_helper'

RSpec.describe Exercises::Import::Quadbase, type: :routine, speed: :slow do
  let(:fixture_path) { 'spec/fixtures/quadbase.json' }

  let(:expected_exercise_stimuli) {
    ['', '<p>This is a multipart question</p>']
  }

  let(:expected_tags) {
    ['exid:qb:q1', 'exid:qb:d2', 'filter-type:import:qb',
     'qb:concept-coach', 'qb:simple', 'qb:multipart', 'qb:m42099',
     'context-cnxmod:ea2bb23c-4fce-4e9d-a46b-3754125da988']
  }

  it 'imports the sample json' do
    expect {
      described_class.call(filename: fixture_path, book_name: 'physics')
    }.to change{ Exercise.count }.by(2)

    imported_exercises = Exercise.order(created_at: :desc).limit(2).to_a

    author = User.joins(:account).find_by(account: {username: 'author'})
    ch = User.joins(:account).find_by(account: {username: 'copyright'})

    imported_exercises.each do |exercise|
      expect(exercise.authors.first.user).to eq author
      expect(exercise.copyright_holders.first.user).to eq ch

      list = exercise.publication.publication_group.list_publication_groups.first.list
      expect(list.name).to eq 'Concept Coach'

      expect(exercise.tags).not_to be_blank
      exercise.tags.map(&:name).each { |tag_name| expect(expected_tags).to include(tag_name) }

      expect(exercise.stimulus).to be_in expected_exercise_stimuli
      expect(exercise.questions.length).to be > 0

      exercise.questions.each do |question|
        expect(question.stimulus).to be_blank
        expect(question.stems.length).to eq 1

        stem = question.stems.first
        expect(stem.content).not_to be_blank
        expect(stem.stem_answers).not_to be_blank
        expect(Set.new(stem.stem_answers.map(&:answer))).to eq Set.new(question.answers)
        expect(stem.stem_answers.any?{ |answer| answer.correctness == 1.0 }).to eq true

        stem.stem_answers.each do |stem_answer|
          expect(stem_answer.feedback).not_to eq ''

          answer = stem_answer.answer
          expect(answer.content).not_to be_blank
        end
      end
    end
  end

  it 'skips exercises with no changes' do
    expect {
      described_class.call(filename: fixture_path, book_name: 'physics')
    }.to change { Exercise.count }.by(2)

    expect {
      described_class.call(filename: fixture_path, book_name: 'physics')
    }.not_to change { Exercise.count }
  end
end
