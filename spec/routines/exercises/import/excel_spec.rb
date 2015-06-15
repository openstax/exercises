require 'rails_helper'

module Exercises::Import
  RSpec.describe Excel do
    let(:fixture_path) { 'spec/fixtures/sample_exercises.xlsx' }

    let!(:author) { FactoryGirl.create :user }
    let!(:ch)     { FactoryGirl.create :user }

    it 'imports the sample spreadsheet' do
      expect {
        Exercises::Import::Excel.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
      }.to change{ Exercise.count }.by(128)

      imported_exercises = Exercise.order(created_at: :desc).limit(128).to_a

      imported_exercises.each do |exercise|
        expect(exercise.authors.first.user).to eq author
        expect(exercise.copyright_holders.first.user).to eq ch

        expect(exercise.list_exercises.first.list.name).to eq 'HS-Physics Chapter 04'

        expect(exercise.tags).to include 'blooms-none'
        expect(exercise.tags).to include 'k12phys'
        expect(exercise.tags).to include 'k12phys-ch04'
        expect(exercise.tags).to satisfy do |tags|
          tag_names = tags.collect { |tag| tag.name }
          (tag_names & ['k12phys-ch04-s01',
                        'k12phys-ch04-s02',
                        'k12phys-ch04-s03',
                        'k12phys-ch04-s04']).length == 1
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
  end
end
