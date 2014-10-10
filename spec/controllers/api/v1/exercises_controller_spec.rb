require "rails_helper"

module Api::V1
  describe ExercisesController, :type => :controller, :api => true, :version => :v1 do

    let!(:application) { FactoryGirl.create :doorkeeper_application }
    let!(:user)        { FactoryGirl.create :user, :agreed_to_terms }
    let!(:admin)       { FactoryGirl.create :user, :administrator, :agreed_to_terms }

    let!(:user_token)        { FactoryGirl.create :doorkeeper_access_token,
                                                  application: application, 
                                                  resource_owner_id: user.id }
    let!(:admin_token)       { FactoryGirl.create :doorkeeper_access_token,
                                                  application: application, 
                                                  resource_owner_id: admin.id }
    let!(:application_token) { FactoryGirl.create :doorkeeper_access_token, 
                                                  application: application, 
                                                  resource_owner_id: nil }

    before(:each) do
      @exercise = FactoryGirl.build(:exercise)
      @exercise.publication.editors << FactoryGirl.build(
        :editor, user: user, publication: @exercise.publication)
    end

    describe "GET index" do

      before(:all) do
        10.times { FactoryGirl.create(:exercise) }

        ad = "%adipisci%"
        Exercise.joins{parts.outer.questions.outer.answers.outer}
                .where{(title.like ad) |\
                       (background.like ad) |\
                       (parts.background.like ad) |\
                       (questions.stem.like ad) |\
                       (answers.content.like ad)}.delete_all

        @exercise_1 = Exercise.new
        Api::V1::ExerciseRepresenter.new(@exercise_1).from_json({
          title: "Lorem ipsum",
          background: "Dolor",
          parts: [{
            background: "Sit amet",
            questions: [{
              stem: "Consectetur adipiscing elit",
              answers: [{
                content: "Sed do eiusmod tempor"
              }]
            }]
          }]
        }.to_json)
        @exercise_1.save!
        @exercise_2 = Exercise.new
        Api::V1::ExerciseRepresenter.new(@exercise_2).from_json({
          title: "Dolorem ipsum",
          background: "Quia dolor",
          parts: [{
            background: "Sit amet",
            questions: [{
              stem: "Consectetur adipisci velit",
              answers: [{
                content: "Sed quia non numquam"
              }]
            }]
          }]
        }.to_json)
        @exercise_2.save!
        @exercises_count = Exercise.count
      end

      it "returns a single matching Exercise" do
        api_get :index, admin_token, parameters: {q: 'content:aDiPiScInG eLiT'}
        expect(response).to have_http_status(:success)

        expected_response = {
          total_count: 1,
          items: [Api::V1::ExerciseRepresenter.new(@exercise_1)]
        }.to_json

        expect(response.body).to eq(expected_response)
      end

      it "returns multiple matching Exercises" do
        api_get :index, admin_token, parameters: {q: 'content:AdIpIsCi'}
        expect(response).to have_http_status(:success)

        expected_response = {
          total_count: 2,
          items: [Api::V1::ExerciseRepresenter.new(@exercise_1),
                  Api::V1::ExerciseRepresenter.new(@exercise_2)]
        }.to_json

        expect(response.body).to eq(expected_response)
      end

      it "sorts by multiple fields in different directions" do
        api_get :index, admin_token, parameters: {q: 'content:aDiPiScI',
                                                 order_by: "number DESC, version ASC"}
        expect(response).to have_http_status(:success)

        expected_response = {
          total_count: 2,
          items: [Api::V1::ExerciseRepresenter.new(@exercise_2),
                  Api::V1::ExerciseRepresenter.new(@exercise_1)]
        }.to_json

        expect(response.body).to eq(expected_response)
      end

    end

    describe "GET show" do

      it "returns the requested Exercise" do
        @exercise.save!
        api_get :show, user_token, parameters: { id: @exercise.uid }
        expect(response).to have_http_status(:success)

        expected_response = Api::V1::ExerciseRepresenter.new(@exercise).to_json
        
        expect(response.body).to eq(expected_response)
      end

    end

    describe "POST create" do

      it "creates the requested Exercise" do
        expect { api_post :create, user_token,
                          raw_post_data: Api::V1::ExerciseRepresenter.new(@exercise).to_json
        }.to change(Exercise, :count).by(1)
        expect(response).to have_http_status(:success)
        new_exercise = Exercise.last
        expect(new_exercise.title).to eq @exercise.title
        expect(new_exercise.background).to eq @exercise.background
        expect(new_exercise.parts.first.background).to eq @exercise.parts.first.background
        expect(new_exercise.questions.first.stem).to eq(
          @exercise.parts.first.questions.first.stem)
        expect(new_exercise.answers.first.content).to eq(
          @exercise.parts.first.questions.first.answers.first.content)
      end

    end

    describe "PATCH update" do

      it "updates the requested Exercise" do
        @exercise.save!
        api_put :update, user_token, parameters: { id: @exercise.uid },
                raw_post_data: { title: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @exercise.reload
        expect(@exercise.title).to eq "Ipsum lorem"
      end

    end

    describe "DELETE destroy" do

      it "deletes the requested Exercise" do
        @exercise.save!
        expect{ api_delete :destroy, user_token,
                           parameters: { id: @exercise.uid }
        }.to change(Exercise, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(Exercise.where(id: @exercise.id)).not_to exist
      end

    end

  end
end
