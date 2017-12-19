require 'rails_helper'

module Exercises::Import
  RSpec.describe Old::Xlsx, type: :routine do
    let(:fixture_path) { 'spec/fixtures/old/sample_exercises.xlsx' }

    let(:expected_los) {
      [
        'k12phys-ch04-s01',
        'k12phys-ch04-s02',
        'k12phys-ch04-s03',
        'k12phys-ch04-s04'
      ]
    }
    let(:author) { FactoryBot.create :user }
    let(:ch)     { FactoryBot.create :user }

    it 'imports the sample spreadsheet' do
      expect {
        described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
      }.to change{ Exercise.count }.by(128)

      imported_exercises = Exercise.order(created_at: :desc).limit(128).to_a

      imported_exercises.each do |exercise|
        expect(exercise.authors.first.user).to eq author
        expect(exercise.copyright_holders.first.user).to eq ch

        list = exercise.publication.publication_group.list_publication_groups.first.list
        expect(list.name).to eq 'HS-Physics Chapter 04'

        tag_names = exercise.tags.map(&:name)
        expect(tag_names).to include 'blooms-none'
        expect(tag_names).to include 'k12phys'
        expect(tag_names).to include 'k12phys-ch04'
        expect((tag_names & expected_los).length).to eq 1

        expect(exercise.stimulus).to be_blank
        expect(exercise.questions.length).to eq 1

        question = exercise.questions.first
        expect(question.stimulus).to be_blank
        expect(question.stems.length).to eq 1

        stem = question.stems.first
        expect(stem.content).not_to be_blank
        expect(stem.stem_answers).not_to be_blank
        expect(Set.new(stem.stem_answers.map { |sa| sa.answer })).to eq Set.new(question.answers)
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
      }.to change{ Exercise.count }.by(128)

      expect {
        described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
      }.not_to change{ Exercise.count }
    end
  end
end
