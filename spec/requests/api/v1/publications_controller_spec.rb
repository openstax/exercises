require 'rails_helper'

RSpec.describe Api::V1::PublicationsController, type: :request, api: true, version: :v1 do

  let(:exercise)   { FactoryBot.create :exercise }
  let(:vocab_term) { FactoryBot.create :vocab_term }

  let!(:exercise_author) { FactoryBot.create :author, publication: exercise.publication }
  let!(:vocab_term_author) { FactoryBot.create :author, publication: vocab_term.publication }

  let!(:exercise_copyright_holder) do
    FactoryBot.create :copyright_holder, publication: exercise.publication
  end
  let!(:vocab_term_copyright_holder) do
    FactoryBot.create :copyright_holder, publication: vocab_term.publication
  end

  let(:exercise_author_token) do
    FactoryBot.create :doorkeeper_access_token, resource_owner_id: exercise_author.user_id
  end
  let(:vocab_term_author_token) do
    FactoryBot.create :doorkeeper_access_token, resource_owner_id: vocab_term_author.user_id
  end

  context "PUT /api/:object_name/:object_id/publish" do
    context "when given an exercise_id" do
      it "publishes the requested exercise" do
        expect(exercise.reload.is_published?).to eq false

        api_put api_exercise_publish_url(exercise.uid), exercise_author_token

        expected_response = Api::V1::Exercises::Representer
                              .new(exercise.reload)
                              .to_json(user_options: { user: exercise_author.user })
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq expected_response
        expect(exercise.is_published?).to eq true
      end

      it "does not publish exercises with a question with a stem with all incorrect answers" do
        expect(exercise.reload.is_published?).to eq false

        exercise.questions.first.stems.first.stem_answers.each do |stem_answer|
          stem_answer.update_attribute :correctness, 0.0
        end

        api_put api_exercise_publish_url(exercise.uid), exercise_author_token

        expected_response = {
          errors: [{ code: 'exercise_has_a_question_with_only_incorrect_answers',
                     message: 'Exercise has a question with only incorrect answers' }],
          status: 422
        }.to_json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
        expect(exercise.is_published?).to eq false
      end
    end

    context "when given a vocab_term_id" do
      it "publishes the requested vocab_term" do
        expect(vocab_term.reload.is_published?).to eq false

        api_put api_vocab_term_publish_url(vocab_term.uid), vocab_term_author_token

        expected_response = \
          Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(vocab_term.reload)
                                                                    .to_json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
        expect(vocab_term.is_published?).to eq true
      end

      it "does not publish vocab_terms without distractors" do
        expect(vocab_term.reload.is_published?).to eq false

        vocab_term.vocab_distractors.delete_all

        api_put api_vocab_term_publish_url(vocab_term.uid), vocab_term_author_token

        expected_response = {
          errors: [{ code: 'vocab_term_must_have_at_least_1_distractor',
                     message: 'Vocab term must have at least 1 distractor' }],
          status: 422
        }.to_json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
        expect(vocab_term.is_published?).to eq false
      end
    end

    context "when given multiple ids" do
      it 'fails with ActionController::BadRequest' do
        expect(exercise.is_published?).to eq false
        expect(vocab_term.is_published?).to eq false

        expect do
          api_put api_exercise_publish_url(exercise.uid), exercise_author_token, params: {
            vocab_term_id: vocab_term.uid
          }.to_json
        end.to raise_error(ActionController::BadRequest)

        expect(exercise.is_published?).to eq false
        expect(vocab_term.is_published?).to eq false
      end
    end
  end

end
