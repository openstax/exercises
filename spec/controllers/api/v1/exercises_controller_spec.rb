require "rails_helper"

module Api::V1
  RSpec.describe ExercisesController, type: :controller, api: true, version: :v1 do

    let(:application)       { FactoryBot.create :doorkeeper_application }
    let(:user)              { FactoryBot.create :user, :agreed_to_terms }
    let(:admin)             { FactoryBot.create :user, :administrator, :agreed_to_terms }

    let(:user_token)        { FactoryBot.create :doorkeeper_access_token,
                                                application: application,
                                                resource_owner_id: user.id }
    let(:admin_token)       { FactoryBot.create :doorkeeper_access_token,
                                                application: application,
                                                resource_owner_id: admin.id }
    let(:application_token) { FactoryBot.create :doorkeeper_access_token,
                                                application: application,
                                                resource_owner_id: nil }

    before do
      @exercise = FactoryBot.build(:exercise)
      @exercise.publication.authors << FactoryBot.build(
        :author, user: user, publication: @exercise.publication
      )
      @exercise.nickname = 'MyExercise'
    end

    context "GET index" do

      before do
        10.times { FactoryBot.create(:exercise, :published) }

        tested_strings = ["%adipisci%", "%draft%"]
        Exercise.joins {questions.outer.stems.outer}
                .joins {questions.outer.answers.outer}
                .where {(title.like_any tested_strings) |\
                       (stimulus.like_any tested_strings) |\
                       (questions.stimulus.like_any tested_strings) |\
                       (stems.content.like_any tested_strings) |\
                       (answers.content.like_any tested_strings)}.delete_all

        @exercise_1 = FactoryBot.build(:exercise, :published)
        Api::V1::Exercises::Representer.new(@exercise_1).from_hash(
          'tags' => ['tag1', 'tag2'],
          'title' => "Lorem ipsum",
          'stimulus' => "Dolor",
          'questions' => [{
            'stimulus' => "Sit amet",
            'stem_html' => "Consectetur adipiscing elit",
            'answers' => [{
              'content_html' => "Sed do eiusmod tempor"
            }]
          }]
        )
        @exercise_1.save!

        @exercise_2 = FactoryBot.build(:exercise, :published)
        Api::V1::Exercises::Representer.new(@exercise_2).from_hash(
          'tags' => ['tag2', 'tag3'],
          'title' => "Dolorem ipsum",
          'stimulus' => "Quia dolor",
          'questions' => [{
            'stimulus' => "Sit amet",
            'stem_html' => "Consectetur adipisci velit",
            'answers' => [{
              'content_html' => "Sed quia non numquam"
            }]
          }]
        )
        @exercise_2.save!

        @exercise_draft = FactoryBot.build(:exercise)
        Api::V1::Exercises::Representer.new(@exercise_draft).from_hash(
          'tags' => ['all', 'the', 'tags'],
          'title' => "DRAFT",
          'stimulus' => "This is a draft",
          'questions' => [{
            'stimulus' => "with no collaborators",
            'stem_html' => "and should not appear",
            'answers' => [{
              'content_html' => "in most searches"
            }]
          }]
        )
        @exercise_draft.save!
      end

      context "no matches" do
        it "does not return drafts that the user is not allowed to see" do
          api_get :index, user_token, parameters: {q: 'content:draft'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 0,
            items: []
          }

          expect(response.body_as_hash).to match(expected_response)
        end
      end

      context "single match" do
        it "returns drafts that the user is allowed to see" do
          @exercise_draft.publication.authors << Author.new(user: user)
          @exercise_draft.reload
          user.reload
          api_get :index, user_token, parameters: {q: 'content:draft'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [a_hash_including(uuid: @exercise_draft.uuid)]
          }

          expect(response.body_as_hash).to match(expected_response)
        end

        it "returns an Exercise matching the content" do
          api_get :index, user_token, parameters: {q: 'content:"aDiPiScInG eLiT"'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [a_hash_including(uuid: @exercise_1.uuid)]
          }

          expect(response.body_as_hash).to match(expected_response)
        end

        it "returns an Exercise matching the tags" do
          api_get :index, user_token, parameters: {q: 'tag:tAg1'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [a_hash_including(uuid: @exercise_1.uuid)]
          }

          expect(response.body_as_hash).to match(expected_response)
        end
      end

      context "multiple matches" do
        it "returns Exercises matching the content" do
          api_get :index, user_token, parameters: {q: 'content:AdIpIsCi'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 2,
            items: [a_hash_including(uuid: @exercise_1.uuid),
                    a_hash_including(uuid: @exercise_2.uuid)]
          }

          expect(response.body_as_hash).to match(expected_response)
        end

        it "returns Exercises matching the tags" do
          api_get :index, user_token, parameters: {q: 'tag:TaG2'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 2,
            items: [a_hash_including(uuid: @exercise_1.uuid),
                    a_hash_including(uuid: @exercise_2.uuid)]
          }

          expect(response.body_as_hash).to match(expected_response)
        end

        it "sorts by multiple fields in different directions" do
          api_get :index, user_token, parameters: {q: 'content:aDiPiScI',
                                                   order_by: "number DESC, version ASC"}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 2,
            items: [a_hash_including(uuid: @exercise_2.uuid),
                    a_hash_including(uuid: @exercise_1.uuid)]
          }

          expect(response.body_as_hash).to match(expected_response)
        end
      end

    end

    context "GET show" do

      before do
        @exercise.publication.publish
        @exercise.save!
        @exercise.reload
        @exercise_1 = @exercise.new_version
        @exercise_1.save!
        @exercise_2 = @exercise.new_version
        @exercise_2.save!
      end

      it "returns the Exercise requested by group_uuid and version" do
        api_get :show, user_token, parameters: {
          id: "#{@exercise.group_uuid}@#{@exercise.version}"
        }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise.visible_versions(can_view_solutions: true)
        )
      end

      it "returns the Exercise requested by uuid" do
        api_get :show, user_token, parameters: { id: @exercise.uuid }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise.visible_versions(can_view_solutions: true)
        )
      end

      it "returns the Exercise requested by uid" do
        api_get :show, user_token, parameters: { id: @exercise.uid }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise.visible_versions(can_view_solutions: true)
        )
      end

      it "returns the latest published Exercise if only the group_uuid is specified" do
        api_get :show, user_token, parameters: { id: @exercise.group_uuid }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise.visible_versions(can_view_solutions: true)
        )
      end

      it "returns the latest published Exercise if only the number is specified" do
        api_get :show, user_token, parameters: { id: @exercise.number }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise.visible_versions(can_view_solutions: true)
        )
      end

      it "returns the latest draft Exercise if \"group_uuid@draft\" is requested" do
        api_get :show, user_token, parameters: { id: "#{@exercise.group_uuid}@draft" }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise_2.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise_2.visible_versions(can_view_solutions: true)
        )
      end

      it "returns the latest draft Exercise if \"number@draft\" is requested" do
        api_get :show, user_token, parameters: { id: "#{@exercise.number}@draft" }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise_2.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise_2.visible_versions(can_view_solutions: true)
        )
      end

      it "returns the latest version of a Exercise if \"@latest\" is requested" do
        @exercise_1.publication.update_attributes(version: 1000)
        api_get :show, user_token, parameters: { id: "#{@exercise.number}@latest" }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise_1.uuid))
        expect(response.body_as_hash[:versions]).to(
          eq @exercise_1.visible_versions(can_view_solutions: true)
        )
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @exercise_1.destroy
        @exercise_2.destroy

        expect do
          api_get :show, user_token, parameters: { id: "#{@exercise.number}@draft" }
        end.to change{ Exercise.count }.by(1)
        expect(response).to have_http_status(:success)

        new_exercise = Exercise.order(:created_at).last
        expect(new_exercise.id).not_to eq @exercise.id
        expect(new_exercise.number).to eq @exercise.number
        expect(new_exercise.version).to eq @exercise.version + 1

        expect(new_exercise.attributes.except('id', 'created_at', 'updated_at'))
          .to eq(@exercise.attributes.except('id', 'created_at', 'updated_at'))
      end

      context 'with solutions' do
        before do
          question = @exercise.questions.first
          question.collaborator_solutions << FactoryBot.create(:collaborator_solution,
                                                                question: question)
        end

        it "shows solutions for published exercises if the requestor is an app" do
          api_get :show, application_token, parameters: { id: @exercise.uid }
          expect(response).to have_http_status(:success)

          expect(response.body_as_hash[:questions].first[:collaborator_solutions]).not_to be_empty
          response.body_as_hash[:questions].first[:answers].each do |answer|
            expect(answer[:correctness]).to be_present
            expect(answer[:feedback_html]).to be_present
          end
        end

        it "shows solutions for published exercises if the requestor is allowed to edit it" do
          api_get :show, user_token, parameters: { id: @exercise.uid }
          expect(response).to have_http_status(:success)

          expect(response.body_as_hash[:questions].first[:collaborator_solutions]).not_to be_empty
          response.body_as_hash[:questions].first[:answers].each do |answer|
            expect(answer[:correctness]).to be_present
            expect(answer[:feedback_html]).to be_present
          end
        end

        it "hides solutions for published exercises if the requestor is not allowed to edit it" do
          @exercise.publication.authors.destroy_all

          api_get :show, user_token, parameters: { id: @exercise.uid }
          expect(response).to have_http_status(:success)

          expect(response.body_as_hash[:questions].first['collaborator_solutions']).to be_nil
          response.body_as_hash[:questions].first[:answers].each do |answer|
            expect(answer[:correctness]).to be_nil
            expect(answer[:feedback_html]).to be_nil
          end
        end

        it "includes versions of the exercise" do
          api_get :show, user_token, parameters: { id: @exercise.uid }
          expect(response).to have_http_status(:success)
          expect(response.body_as_hash[:versions]).to(
            eq([@exercise_2.version, @exercise_1.version, @exercise.version])
          )
        end

      end

    end

    context "POST create" do
      before { Rails.cache.clear }

      it "creates the requested Exercise and assigns the user as author and CR holder" do
        expect do
          api_post :create, user_token, raw_post_data: Api::V1::Exercises::Representer.new(
            @exercise
          ).to_hash(user_options: { user: user })
        end.to change { Exercise.count }.by(1)
        expect(response).to have_http_status(:success)

        new_exercise = Exercise.last
        expect(new_exercise.nickname).to eq 'MyExercise'
        expect(new_exercise.title).to eq @exercise.title
        expect(new_exercise.stimulus).to eq @exercise.stimulus

        expect(new_exercise.questions.first.stimulus)
          .to eq @exercise.questions.first.stimulus

        expect(new_exercise.questions.first.stems.first.content).to eq(
          @exercise.questions.first.stems.first.content)

        db_answers = new_exercise.questions.first.answers
        json_answers = @exercise.questions.first.answers
        expect(Set.new db_answers.map(&:content)).to eq(Set.new json_answers.map(&:content))

        db_solutions = new_exercise.questions.first.collaborator_solutions
        json_solutions = @exercise.questions.first.collaborator_solutions

        expect(Set.new db_solutions.map(&:content)).to eq(Set.new json_solutions.map(&:content))

        expect(new_exercise.authors.first.user).to eq user
        expect(new_exercise.copyright_holders.first.user).to eq user
      end

      it "creates the exercise with a collaborator solution" do
        exercise = FactoryBot.build(:exercise, collaborator_solutions_count: 1)
        exercise.publication.authors << FactoryBot.build(
          :author, user: user, publication: @exercise.publication
        )

        expect do
          api_post :create, user_token, raw_post_data: Api::V1::Exercises::Representer.new(
            exercise
          ).to_hash(user_options: { user: user })
        end.to change { Exercise.count }.by(1)
        expect(response).to have_http_status(:success)

        new_exercise = Exercise.last

        expect(new_exercise.questions.first.collaborator_solutions).not_to be_empty
      end

      it "fails if the nickname has already been taken" do
        FactoryBot.create :publication_group, nickname: 'MyExercise'

        expect do
          api_post :create, user_token, raw_post_data: Api::V1::Exercises::Representer.new(
            @exercise
          ).to_hash(user_options: { user: user })
        end.not_to change { Exercise.count }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body_as_hash[:errors].first[:code]).to eq 'nickname_has_already_been_taken'
      end

    end

    context "PATCH update" do

      before do
        @exercise.save!
        @exercise.reload
        @old_attributes = @exercise.attributes
      end

      it "updates the requested Exercise" do
        api_patch :update, user_token, parameters: { id: @exercise.uid }, raw_post_data: {
          nickname: 'MyExercise', title: "Ipsum lorem"
        }
        expect(response).to have_http_status(:success)
        @exercise.reload
        new_attributes = @exercise.attributes

        expect(@exercise.nickname).to eq 'MyExercise'
        expect(@exercise.title).to eq "Ipsum lorem"
        expect(new_attributes.except('title', 'updated_at'))
          .to eq(@old_attributes.except('title', 'updated_at'))
      end

      it "fails if the exercise is published and \"@draft\" was not requested" do
        @exercise.publication.publish.save!

        expect do
          api_patch :update, user_token, parameters: { id: @exercise.uid }, raw_post_data: {
            nickname: 'MyExercise', title: "Ipsum lorem"
          }
        end.to raise_error(SecurityTransgression)
        @exercise.reload

        expect(@exercise.attributes.except('updated_at')).to eq @old_attributes.except('updated_at')
      end

      it "fails if the nickname has already been taken" do
        FactoryBot.create :publication_group, nickname: 'MyExercise2'

        api_patch :update, user_token, parameters: { id: @exercise.uid }, raw_post_data: {
          nickname: 'MyExercise2', title: "Ipsum lorem"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body_as_hash[:errors].first[:code]).to eq 'nickname_has_already_been_taken'

        @exercise.reload
        expect(@exercise.attributes).to eq @old_attributes
      end

      it "updates the latest draft Exercise if \"@draft\" is requested" do
        @exercise.publication.publish.save!
        exercise_2 = @exercise.new_version
        exercise_2.save!
        exercise_2.reload

        id = "#{@exercise.number}@draft"
        api_patch :update, user_token, parameters: { id: id }, raw_post_data: {
          nickname: 'MyExercise', title: "Ipsum lorem"
        }
        expect(response).to have_http_status(:success)
        @exercise.reload

        expect(@exercise.attributes.except('updated_at')).to eq @old_attributes.except('updated_at')

        uid = response.body_as_hash[:uid]
        new_exercise = Exercise.with_id(uid).first
        new_attributes = new_exercise.attributes

        expect(new_exercise.nickname).to eq 'MyExercise'
        expect(new_exercise.title).to eq "Ipsum lorem"
        expect(new_attributes.except('title', 'updated_at'))
          .to eq(exercise_2.attributes.except('title', 'updated_at'))
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @exercise.publication.publish.save!

        id = "#{@exercise.number}@draft"
        expect do
          api_patch :update, user_token, parameters: { id: id }, raw_post_data: {
            nickname: 'MyExercise', title: "Ipsum lorem"
          }
        end.to change{ Exercise.count }.by(1)
        expect(response).to have_http_status(:success)
        @exercise.reload

        expect(@exercise.attributes.except('updated_at')).to eq @old_attributes.except('updated_at')

        uid = response.body_as_hash[:uid]
        new_exercise = Exercise.with_id(uid).first
        new_attributes = new_exercise.attributes

        expect(new_exercise.id).not_to eq @exercise.id
        expect(new_exercise.number).to eq @exercise.number
        expect(new_exercise.version).to eq @exercise.version + 1
        expect(new_exercise.nickname).to eq 'MyExercise'
        expect(new_exercise.title).to eq "Ipsum lorem"
        expect(new_attributes.except('id', 'title', 'created_at', 'updated_at'))
          .to eq(@old_attributes.except('id', 'title', 'created_at', 'updated_at'))
      end

    end

    context "DELETE destroy" do

      it "deletes the requested draft Exercise" do
        @exercise.save!
        expect do
          api_delete :destroy, user_token, parameters: { id: @exercise.uid }
        end.to change(Exercise, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(Exercise.where(id: @exercise.id)).not_to exist
      end

    end

  end
end
