require "rails_helper"

module Api::V1
  RSpec.describe PublicationsController, type: :controller, api: true, version: :v1 do

    let!(:exercise) { FactoryGirl.create :exercise }

    let!(:solution) { FactoryGirl.create :solution }

    let!(:exercise_author)   { FactoryGirl.create :author }
    let!(:exercise) { exercise_author.publication.publishable }

    let!(:solution) { FactoryGirl.create :solution }
    let!(:solution_author) {
      FactoryGirl.create :author, publication: solution.publication
    }

    let!(:exercise_author_token) {
      FactoryGirl.create :doorkeeper_access_token,
                         resource_owner_id: exercise_author.user_id
    }
    let!(:solution_author_token) {
      FactoryGirl.create :doorkeeper_access_token,
                         resource_owner_id: solution_author.user_id
    }

    context "PUT publish" do
      context "when given an exercise_id" do
        it "publishes the requested exercise" do
          expect(exercise.reload.is_published?).to eq false

          api_put :publish, exercise_author_token,
                             parameters: { exercise_id: exercise.id.to_s }

          expected_response = Api::V1::ExerciseRepresenter.new(exercise.reload).to_json
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
          expect(exercise.is_published?).to eq true
        end
      end

      context "when given a solution_id" do
        it "publishes the requested solution" do
          expect(solution.reload.is_published?).to eq false

          api_put :publish, solution_author_token, parameters: {
            exercise_id: solution.question.exercise_id.to_s,
            question_id: solution.question_id,
            solution_id: solution.id.to_s
          }

          expected_response = Api::V1::SolutionRepresenter.new(solution.reload).to_json
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
          expect(solution.is_published?).to eq true
        end
      end
    end

  end
end
