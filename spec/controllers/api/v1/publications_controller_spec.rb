require "rails_helper"

module Api::V1
  RSpec.describe PublicationsController, type: :controller, api: true, version: :v1 do

    let(:exercise)        { FactoryBot.create :exercise }
    let(:vocab_term)      { FactoryBot.create :vocab_term }
    let(:solution)        { FactoryBot.create :community_solution }

    let(:exercise_author) {
      FactoryBot.create :author, publication: exercise.publication
    }
    let(:vocab_term_author) {
      FactoryBot.create :author, publication: vocab_term.publication
    }
    let(:solution_author) {
      FactoryBot.create :author, publication: solution.publication
    }

    let(:exercise_author_token) {
      FactoryBot.create :doorkeeper_access_token,
                         resource_owner_id: exercise_author.user_id
    }
    let(:vocab_term_author_token) {
      FactoryBot.create :doorkeeper_access_token,
                         resource_owner_id: vocab_term_author.user_id
    }
    let(:solution_author_token) {
      FactoryBot.create :doorkeeper_access_token,
                         resource_owner_id: solution_author.user_id
    }

    context "PUT publish" do
      context "when given an exercise_id" do
        it "publishes the requested exercise" do
          expect(exercise.reload.is_published?).to eq false

          api_put :publish, exercise_author_token,
                            params: { exercise_id: exercise.uid.to_s }

          expected_response = Api::V1::Exercises::Representer
                                .new(exercise.reload)
                                .to_json(user_options: { user: exercise_author.user })
          expect(response).to have_http_status(:success)
          expect(response.body).to eq expected_response
          expect(exercise.is_published?).to eq true
        end

        it "does not publish exercises with a question with a stem with all incorrect answers" do
          expect(exercise.reload.is_published?).to eq false

          exercise.questions.first.stems.first.stem_answers.each do |stem_answer|
            stem_answer.update_attribute :correctness, 0.0
          end

          api_put :publish, exercise_author_token,
                            params: { exercise_id: exercise.uid.to_s }

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

          api_put :publish, vocab_term_author_token,
                            params: { vocab_term_id: vocab_term.uid.to_s }

          expected_response = \
            Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(vocab_term.reload)
                                                                      .to_json
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
          expect(vocab_term.is_published?).to eq true
        end

        it "does not publish vocab_terms without distractors" do
          expect(vocab_term.reload.is_published?).to eq false

          vocab_term.vocab_distractors.delete_all

          api_put :publish, vocab_term_author_token,
                            params: { vocab_term_id: vocab_term.uid.to_s }

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

      context "when given a community_solution_id" do
        it "publishes the requested community solution" do
          expect(solution.reload.is_published?).to eq false

          api_put :publish, solution_author_token, params: {
            community_solution_id: solution.uid.to_s
          }

          expected_response = Api::V1::Exercises::CommunitySolutionRepresenter.new(solution.reload).to_json
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
          expect(solution.is_published?).to eq true
        end
      end

      context "when given multiple ids" do
        it 'fails with ActionController::BadRequest' do
          expect(exercise.is_published?).to eq false
          expect(vocab_term.is_published?).to eq false
          expect(solution.is_published?).to eq false

          expect{
            api_put :publish, exercise_author_token,
                              params: { exercise_id: exercise.uid.to_s,
                                            vocab_term_id: vocab_term.uid.to_s,
                                            community_solution_id: solution.uid.to_s }
          }.to raise_error(ActionController::BadRequest)

          expect(exercise.is_published?).to eq false
          expect(vocab_term.is_published?).to eq false
          expect(solution.is_published?).to eq false
        end
      end
    end

  end
end
