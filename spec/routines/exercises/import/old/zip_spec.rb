require 'rails_helper'

module Exercises::Import
  RSpec.describe Old::Zip, type: :routine do
    let(:fixture_path) { 'spec/fixtures/old/sample_exercises.zip' }

    let(:author) { FactoryBot.create :user }
    let(:ch)     { FactoryBot.create :user }

    it 'imports the sample zip file' do
      attachment_count = Attachment.count
      expect {
        described_class.call(filename: fixture_path, author_id: author.id, ch_id: ch.id)
      }.to change{ Exercise.count }.by(215)
      expect(Attachment.count).to eq (attachment_count + 15)

      imported_exercises = Exercise.order(created_at: :desc).limit(200).to_a

      imported_exercises.each do |exercise|
        expect(exercise.authors.first.user).to eq author
        expect(exercise.copyright_holders.first.user).to eq ch

        list = exercise.publication.publication_group.list_publication_groups.first.list
        expect(list.name).not_to be_blank

        expect(exercise.tags).not_to be_blank

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
  end
end
