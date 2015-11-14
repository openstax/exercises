require "rails_helper"

module Api::V1
  describe ExercisesController, type: :controller, api: true, version: :v1 do

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
        :editor, user: user, publication: @exercise.publication
      )
    end

    describe "GET index" do

      before(:each) do
        10.times { FactoryGirl.create(:exercise) }

        ad = "%adipisci%"
        Exercise.joins{questions.outer.stems.outer}
                .joins{questions.outer.answers.outer}
                .where{(title.like ad) |\
                       (stimulus.like ad) |\
                       (questions.stimulus.like ad) |\
                       (stems.content.like ad) |\
                       (answers.content.like ad)}.delete_all

        @exercise_1 = Exercise.new
        Api::V1::ExerciseRepresenter.new(@exercise_1).from_json({
          tags: ['tag1', 'tag2'],
          title: "Lorem ipsum",
          stimulus: "Dolor",
          questions: [{
            stimulus: "Sit amet",
            stem_html: "Consectetur adipiscing elit",
            answers: [{
              content_html: "Sed do eiusmod tempor"
            }]
          }]
        }.to_json)
        @exercise_1.save!

        @exercise_2 = Exercise.new
        Api::V1::ExerciseRepresenter.new(@exercise_2).from_json({
          tags: ['tag2', 'tag3'],
          title: "Dolorem ipsum",
          stimulus: "Quia dolor",
          questions: [{
            stimulus: "Sit amet",
            stem_html: "Consectetur adipisci velit",
            answers: [{
              content_html: "Sed quia non numquam"
            }]
          }]
        }.to_json)
        @exercise_2.save!

        @exercises_count = Exercise.count
      end

      context "single match" do
        it "returns an Exercise matching the content" do
          api_get :index, admin_token, parameters: {q: 'content:aDiPiScInG eLiT'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [Api::V1::ExerciseRepresenter.new(@exercise_1)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end

        it "returns an Exercise matching the tags" do
          api_get :index, admin_token, parameters: {q: 'tag:tAg1'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [Api::V1::ExerciseRepresenter.new(@exercise_1)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end
      end

      context "multiple matches" do
        it "returns Exercises matching the content" do
          api_get :index, admin_token, parameters: {q: 'content:AdIpIsCi'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 2,
            items: [Api::V1::ExerciseRepresenter.new(@exercise_1),
                    Api::V1::ExerciseRepresenter.new(@exercise_2)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end

        it "returns Exercises matching the tags" do
          api_get :index, admin_token, parameters: {q: 'tag:TaG2'}
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

    end

    describe "GET show" do

      before(:each) do
        @exercise.publication.publish
        @exercise.save!
        @exercise.reload

        @exercise_2 = @exercise.new_version
        @exercise_2.save!
      end

      it "returns the Exercise requested by uid" do
        api_get :show, user_token, parameters: { id: @exercise.uid }
        expect(response).to have_http_status(:success)

        expected_response = Api::V1::ExerciseRepresenter.new(@exercise).to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "returns the latest published Exercise if no version is specified" do
        api_get :show, user_token, parameters: { id: @exercise.number }
        expect(response).to have_http_status(:success)

        expected_response = Api::V1::ExerciseRepresenter.new(@exercise).to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "returns the latest draft Exercise if \"@draft\" is requested" do
        api_get :show, user_token, parameters: { id: "#{@exercise.number}@draft" }
        expect(response).to have_http_status(:success)

        expected_response = Api::V1::ExerciseRepresenter.new(@exercise_2.reload)
                                                        .to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @exercise_2.destroy

        expect{ api_get :show, user_token, parameters: { id: "#{@exercise.number}@draft" } }.to(
          change{ Exercise.count }.by(1)
        )
        expect(response).to have_http_status(:success)

        new_exercise = Exercise.order(:created_at).last
        expect(new_exercise.id).not_to eq @exercise.id
        expect(new_exercise.number).to eq @exercise.number
        expect(new_exercise.version).to eq @exercise.version + 1

        expect(new_exercise.attributes.except('id', 'uid', 'title', 'created_at', 'updated_at'))
          .to eq(@exercise.attributes.except('id', 'uid', 'title', 'created_at', 'updated_at'))

        expected_response = Api::V1::ExerciseRepresenter.new(new_exercise).to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      context 'with solutions' do
        before(:each) do
          question = @exercise.questions.first
          question.solutions << FactoryGirl.create(:solution, :published, question: question)
        end

        it "shows solutions for published exercises if the requestor is an app" do
          api_get :show, application_token, parameters: { id: @exercise.uid }
          expect(response).to have_http_status(:success)

          response_hash = JSON.parse(response.body)
          expect(response_hash['questions'].first['solutions']).not_to be_empty
          response_hash['questions'].first['answers'].each do |answer|
            expect(answer['correctness']).to be_present
            expect(answer['feedback_html']).to be_present
          end
        end

        it "shows solutions for published exercises if the requestor is allowed to edit it" do
          api_get :show, user_token, parameters: { id: @exercise.uid }
          expect(response).to have_http_status(:success)

          response_hash = JSON.parse(response.body)
          expect(response_hash['questions'].first['solutions']).not_to be_empty
          response_hash['questions'].first['answers'].each do |answer|
            expect(answer['correctness']).to be_present
            expect(answer['feedback_html']).to be_present
          end
        end

        it "hides solutions for published exercises if the requestor is not allowed to edit it" do
          @exercise.publication.editors.destroy_all

          api_get :show, user_token, parameters: { id: @exercise.uid }
          expect(response).to have_http_status(:success)

          response_hash = JSON.parse(response.body)
          expect(response_hash['questions'].first['solutions']).to be_nil
          response_hash['questions'].first['answers'].each do |answer|
            expect(answer['correctness']).to be_nil
            expect(answer['feedback_html']).to be_nil
          end
        end

      end

    end

    describe "POST create" do

      it "creates the requested Exercise and assigns the user as author and CR holder" do
        expect { api_post :create, user_token,
                          raw_post_data: Api::V1::ExerciseRepresenter.new(
                                           @exercise
                                         ).to_json
        }.to change(Exercise, :count).by(1)
        expect(response).to have_http_status(:success)

        new_exercise = Exercise.last
        expect(new_exercise.title).to eq @exercise.title
        expect(new_exercise.stimulus).to eq @exercise.stimulus

        expect(new_exercise.questions.first.stimulus)
          .to eq @exercise.questions.first.stimulus

        expect(new_exercise.questions.first.stems.first.content).to eq(
          @exercise.questions.first.stems.first.content)

        db_answers = new_exercise.questions.first.answers
        json_answers = @exercise.questions.first.answers
        expect(Set.new db_answers.collect { |answer| answer.content }).to(
          eq(Set.new json_answers.collect { |answer| answer.content })
        )

        expect(new_exercise.authors.first.user).to eq user
        expect(new_exercise.copyright_holders.first.user).to eq user
      end

    end

    describe "PATCH update" do

      before(:each) do
        @exercise.save!
        @exercise.reload
        @old_attributes = @exercise.attributes
      end

      it "updates the requested Exercise" do
        api_patch :update, user_token, parameters: { id: @exercise.uid },
                                       raw_post_data: { title: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @exercise.reload
        new_attributes = @exercise.attributes

        expect(@exercise.title).to eq "Ipsum lorem"
        expect(new_attributes.except('title', 'updated_at'))
          .to eq(@old_attributes.except('title', 'updated_at'))
      end

      it "fails if the exercise is published and \"@draft\" was not requested" do
        @exercise.publication.publish.save!

        expect{ api_patch :update, user_token, parameters: { id: @exercise.uid },
                                               raw_post_data: { title: "Ipsum lorem" } }.to(
          raise_error(SecurityTransgression)
        )
        @exercise.reload

        expect(@exercise.attributes).to eq @old_attributes
      end

      it "updates the latest draft Exercise if \"@draft\" is requested" do
        @exercise.publication.publish.save!
        exercise_2 = @exercise.new_version
        exercise_2.save!
        exercise_2.reload

        api_patch :update, user_token, parameters: { id: "#{@exercise.number}@draft" },
                                       raw_post_data: { title: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @exercise.reload

        expect(@exercise.attributes).to eq @old_attributes

        uid = JSON.parse(response.body)['uid']
        new_exercise = Exercise.with_uid(uid).first
        new_attributes = new_exercise.attributes

        expect(new_exercise.title).to eq "Ipsum lorem"
        expect(new_attributes.except('title', 'updated_at'))
          .to eq(exercise_2.attributes.except('title', 'updated_at'))
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @exercise.publication.publish.save!

        expect{
          api_patch :update, user_token, parameters: { id: "#{@exercise.number}@draft" },
                                         raw_post_data: { title: "Ipsum lorem" } }.to(
          change{ Exercise.count }.by(1)
        )
        expect(response).to have_http_status(:success)
        @exercise.reload

        expect(@exercise.attributes).to eq @old_attributes

        uid = JSON.parse(response.body)['uid']
        new_exercise = Exercise.with_uid(uid).first
        new_attributes = new_exercise.attributes

        expect(new_exercise.id).not_to eq @exercise.id
        expect(new_exercise.number).to eq @exercise.number
        expect(new_exercise.version).to eq @exercise.version + 1
        expect(new_exercise.title).to eq "Ipsum lorem"
        expect(new_attributes.except('id', 'uid', 'title', 'created_at', 'updated_at'))
          .to eq(@old_attributes.except('id', 'uid', 'title', 'created_at', 'updated_at'))
      end

    end

    describe "DELETE destroy" do

      it "deletes the requested draft Exercise" do
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
