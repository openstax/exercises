require 'rails_helper'

module Exercises::Import
  RSpec.describe Quadbase do
    let(:fixture_path) { 'spec/fixtures/quadbase.json' }

    let(:expected_exercise_stimuli) {
      ['', '<p>This is a multipart question</p>']
    }

    let(:expected_tags) {
      ['exid:qb:q1', 'exid:qb:d2', 'filter-type:qb',
       'qb:concept coach', 'qb:simple', 'qb:multipart', 'qb:m1000',
       'cnxmod:d6c29b47-d560-4571-bef0-b51fa3461d3b']
    }

    it 'imports the sample json' do
      expect {
        described_class.call(file: fixture_path)
      }.to change{ Exercise.count }.by(2)

      imported_exercises = Exercise.order(created_at: :desc).limit(2).to_a

      author = User.joins(:account).find_by(account: {username: 'author'})
      ch = User.joins(:account).find_by(account: {username: 'copyright'})

      imported_exercises.each do |exercise|
        expect(exercise.authors.first.user).to eq author
        expect(exercise.copyright_holders.first.user).to eq ch

        expect(exercise.list_exercises.first.list.name).to eq 'Concept Coach'

        expect(exercise.tags).not_to be_blank
        exercise.tags.map(&:name).each{ |tag_name| expect(tag_name).to be_in expected_tags }

        expect(exercise.stimulus).to be_in expected_exercise_stimuli
        expect(exercise.questions.length).to be > 0

        exercise.questions.each do |question|
          expect(question.stimulus).to be_blank
          expect(question.stems.length).to eq 1

          stem = question.stems.first
          expect(stem.content).not_to be_blank
          expect(stem.stem_answers).not_to be_blank
          expect(Set.new(stem.stem_answers.map{ |sa| sa.answer })).to eq Set.new(question.answers)
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
        described_class.call(file: fixture_path)
      }.to change{ Exercise.count }.by(2)

      expect {
        described_class.call(file: fixture_path)
      }.not_to change{ Exercise.count }
    end
  end
end
