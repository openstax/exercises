require 'rails_helper'

module Exercises::Import
  RSpec.describe Excel do
    let(:fixture_path) { 'spec/fixtures/sample_exercises.xlsx' }

    let!(:author) { FactoryGirl.create :user }
    let!(:ch)     { FactoryGirl.create :user }

    it 'imports the sample spreadsheet' do
      expect {
        described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
      }.to change{ Exercise.count }.by(200)

      imported_exercises = Exercise.order(created_at: :desc).limit(200).to_a

      imported_exercises.each do |exercise|
        expect(exercise.authors.first.user).to eq author
        expect(exercise.copyright_holders.first.user).to eq ch

        expect(['HS-Physics Chapter 03', 'HS-Physics Chapter 04']).to include(
          exercise.list_exercises.first.list.name
        )

        expect(exercise.tags).not_to be_blank
        expect(exercise.tags).to satisfy do |tags|
          tag_names = tags.collect { |tag| tag.name }
          (tag_names & ['lo:k12phys-3-1-1',
                        'lo:k12phys-3-1-2',
                        'lo:k12phys-3-2-1',
                        'lo:k12phys-3-2-2',
                        'lo:k12phys-4-1-1',
                        'lo:k12phys-4-1-2',
                        'lo:k12phys-4-2-1',
                        'lo:k12phys-4-2-2',
                        'lo:k12phys-4-3-1',
                        'lo:k12phys-4-3-2',
                        'lo:k12phys-4-4-1',
                        'lo:k12phys-4-4-2']).length == 1
        end


        expect(exercise.stimulus).to be_blank
        expect(exercise.questions.length).to eq 1

        question = exercise.questions.first
        expect(question.stimulus).to be_blank
        expect(question.stems.length).to eq 1

        stem = question.stems.first
        expect(stem.content).not_to be_blank
        expect(stem.stem_answers).not_to be_blank
        expect(Set.new(stem.stem_answers.collect{ |sa| sa.answer })).to eq Set.new(question.answers)
        expect(stem.stem_answers.any?{ |answer| answer.correctness == 1.0 }).to eq true

        stem.stem_answers.each do |stem_answer|
          expect(stem_answer.feedback).not_to eq ''

          answer = stem_answer.answer
          expect(answer.content).not_to be_blank
        end
      end
    end

    it 'skips exercises with no changes' do
      expect {
        described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
      }.to change{ Exercise.count }.by(200)

      expect {
        described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
      }.not_to change{ Exercise.count }
    end
  end
end
