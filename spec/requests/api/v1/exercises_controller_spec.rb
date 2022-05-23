require 'rails_helper'

RSpec.describe Api::V1::ExercisesController, type: :request, api: true, version: :v1 do
  before(:all) do
    DatabaseCleaner.start

    application = FactoryBot.create :doorkeeper_application
    @user_1 = FactoryBot.create :user, :agreed_to_terms
    @user_2 = FactoryBot.create :user, :agreed_to_terms
    admin = FactoryBot.create :user, :administrator, :agreed_to_terms
    @application_token = FactoryBot.create :doorkeeper_access_token,
                                           application: application,
                                           resource_owner_id: nil
    @user_1_token = FactoryBot.create :doorkeeper_access_token,
                                      application: application,
                                      resource_owner_id: @user_1.id
    FactoryBot.create :doorkeeper_access_token,
                      application: application,
                      resource_owner_id: admin.id

    @exercise = FactoryBot.build(:exercise)
    @exercise.publication.authors << FactoryBot.create(
      :author, user: @user_1, publication: @exercise.publication
    )
    @exercise.publication.copyright_holders << FactoryBot.create(
      :copyright_holder, user: @user_1, publication: @exercise.publication
    )
    @exercise.nickname = 'MyExercise'
    @exercise.save!
  end
  after(:all) { DatabaseCleaner.clean }

  {
    get: { api_exercises: 'exercises', search_api_exercises: 'exercises/search' },
    post: { search_api_exercises: 'exercises/search' }
  }.each do |method, cases|
    cases.each do |url_method, path|
      context "#{method.to_s.upcase} /api/#{path}" do
        before(:all) do
          DatabaseCleaner.start

          10.times { FactoryBot.create(:exercise, :published) }

          ex = Exercise.arel_table
          qu = Question.arel_table
          st = Stem.arel_table
          ans = Answer.arel_table

          tested_strings = [ "%adipisci%", "%draft%" ]

          ex_ids = Exercise.left_joins(questions: [:stems, :answers]).where(
                     ex[:title].matches_any(tested_strings)
                       .or(ex[:stimulus].matches_any(tested_strings))
                       .or(qu[:stimulus].matches_any(tested_strings))
                       .or(st[:content].matches_any(tested_strings))
                       .or(ans[:content].matches_any(tested_strings))
                   ).pluck(:id)

          Exercise.where(id: ex_ids).destroy_all

          @exercise_1 = FactoryBot.build(:exercise, :published)
          Api::V1::Exercises::Representer.new(@exercise_1).from_hash(
            {
              tags: ['tag1', 'tag2'],
              title: "Lorem ipsum",
              stimulus: "Dolor",
              questions: [{
                stimulus: "Sit amet",
                stem_html: "Consectetur adipiscing elit",
                answers: [{
                  content_html: "Sed do eiusmod tempor"
                }],
                formats: [ 'multiple-choice', 'free-response' ]
              }]
            }.deep_stringify_keys
          )
          @exercise_1.publication.authors << FactoryBot.create(
            :author, user: @user_2, publication: @exercise_1.publication
          )
          @exercise_1.publication.copyright_holders << FactoryBot.create(
            :copyright_holder, user: @user_2, publication: @exercise_1.publication
          )
          @exercise_1.save!

          @exercise_2 = FactoryBot.build(:exercise, :published)
          Api::V1::Exercises::Representer.new(@exercise_2).from_hash(
            {
              tags: ['tag2', 'tag3'],
              title: "Dolorem ipsum",
              stimulus: "Quia dolor",
              questions: [{
                stimulus: "Sit amet",
                stem_html: "Consectetur adipisci velit",
                answers: [{
                  content_html: "Sed quia non numquam"
                }],
                formats: [ 'multiple-choice', 'free-response' ]
              }]
            }.deep_stringify_keys
          )
          @exercise_2.publication.authors << FactoryBot.create(
            :author, user: @user_2, publication: @exercise_2.publication
          )
          @exercise_2.publication.copyright_holders << FactoryBot.create(
            :copyright_holder, user: @user_2, publication: @exercise_2.publication
          )
          @exercise_2.save!

          @exercise_draft = FactoryBot.build(:exercise)
          Api::V1::Exercises::Representer.new(@exercise_draft).from_hash(
            {
              tags: ['all', 'the', 'tags'],
              title: "DRAFT",
              stimulus: "This is a draft",
              questions: [{
                stimulus: "with no collaborators",
                stem_html: "and should not appear",
                answers: [{
                  content_html: "in most searches"
                }],
                formats: [ 'multiple-choice', 'free-response' ]
              }]
            }.deep_stringify_keys
          )
          @exercise_draft.save!
        end
        after(:all) { DatabaseCleaner.clean }

        let(:api_method) { "api_#{method}" }
        let(:url_proc) { ->(params) { send "#{url_method}_url", params } }

        context "no matches" do
          it "does not return drafts that the user is not allowed to see" do
            send api_method, url_proc.call(q: 'content:draft'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 0,
              items: []
            }

            expect(response.body_as_hash).to match(expected_response)
          end
        end

        context "single match" do
          it "returns drafts that the user is allowed to see" do
            @exercise_draft.publication.authors << Author.new(user: @user_1)
            @exercise_draft.publication.copyright_holders << CopyrightHolder.new(user: @user_1)
            send api_method, url_proc.call(q: 'content:draft'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @exercise_draft.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns an Exercise matching the content" do
            send api_method, url_proc.call(q: 'content:"aDiPiScInG eLiT"'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @exercise_1.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns an Exercise matching the tags" do
            send api_method, url_proc.call(q: 'tag:tAg1'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @exercise_1.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end
        end

        context "multiple matches" do
          it "returns Exercises matching the content" do
            send api_method, url_proc.call(q: 'content:AdIpIsCi'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @exercise_1.uuid),
                      a_hash_including(uuid: @exercise_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns Exercises matching the tags" do
            send api_method, url_proc.call(q: 'tag:TaG2'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @exercise_1.uuid),
                      a_hash_including(uuid: @exercise_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "sorts by multiple fields in different directions" do
            send api_method, url_proc.call(
              q: 'content:aDiPiScI', order_by: 'number DESC, version ASC'
            ), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @exercise_2.uuid),
                      a_hash_including(uuid: @exercise_1.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end
        end
      end
    end
  end

  context "GET /api/exercises/:id" do
    before(:all) do
      DatabaseCleaner.start

      @exercise.publication.publish.save!
      @exercise_1 = @exercise.new_version
      @exercise_1.save!
      @exercise_2 = @exercise.new_version
      @exercise_2.save!
    end
    after(:all) { DatabaseCleaner.clean }

    before do
      @exercise_1.reload
      @exercise_2.reload
    end

    it "returns the Exercise requested by group_uuid and version" do
      api_get api_exercise_url("#{@exercise.group_uuid}@#{@exercise.version}"), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise.visible_versions(can_view_solutions: true)
      )
    end

    it "returns the Exercise requested by uuid" do
      api_get api_exercise_url(@exercise.uuid), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise.visible_versions(can_view_solutions: true)
      )
    end

    it "returns the Exercise requested by uid" do
      api_get api_exercise_url(@exercise.uid), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise.visible_versions(can_view_solutions: true)
      )
    end

    it "returns the latest published Exercise if only the group_uuid is specified" do
      api_get api_exercise_url(@exercise.group_uuid), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise.visible_versions(can_view_solutions: true)
      )
    end

    it "returns the latest published Exercise if only the number is specified" do
      api_get api_exercise_url(@exercise.number), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise.visible_versions(can_view_solutions: true)
      )
    end

    it "returns the latest draft Exercise if \"group_uuid@draft\" is requested" do
      api_get api_exercise_url("#{@exercise.group_uuid}@draft"), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise_2.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise_2.visible_versions(can_view_solutions: true)
      )
    end

    it "returns the latest draft Exercise if \"number@draft\" is requested" do
      api_get api_exercise_url("#{@exercise.number}@draft"), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise_2.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise_2.visible_versions(can_view_solutions: true)
      )
    end

    it "returns the latest version of a Exercise if \"@latest\" is requested" do
      @exercise_1.publication.update(version: 1000)
      api_get api_exercise_url("#{@exercise.number}@latest"), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @exercise_1.uuid))
      expect(response.body_as_hash[:versions]).to(
        eq @exercise_1.visible_versions(can_view_solutions: true)
      )
    end

    it "creates a new draft version if no draft and \"@draft\" is requested" do
      @exercise_1.destroy
      @exercise_2.destroy

      expect do
        api_get api_exercise_url("#{@exercise.number}@draft"), @user_1_token
      end.to change { Exercise.count }.by(1)
      expect(response).to have_http_status(:ok)

      new_exercise = Exercise.order(:created_at).last
      expect(new_exercise.id).not_to eq @exercise.id
      expect(new_exercise.number).to eq @exercise.number
      expect(new_exercise.version).to eq @exercise.version + 1

      expect(new_exercise.attributes.except('id', 'created_at', 'updated_at'))
        .to eq(@exercise.attributes.except('id', 'created_at', 'updated_at'))
    end

    context 'with solutions' do
      before(:all) do
        DatabaseCleaner.start

        question = @exercise.questions.first
        question.collaborator_solutions << FactoryBot.create(:collaborator_solution,
                                                              question: question)
      end
      after(:all) { DatabaseCleaner.clean }

      it "shows solutions for published exercises if the requestor is an app" do
        api_get api_exercise_url(@exercise.uid), @application_token
        expect(response).to have_http_status(:ok)

        expect(response.body_as_hash[:questions].first[:collaborator_solutions]).not_to be_empty
        response.body_as_hash[:questions].first[:answers].each do |answer|
          expect(answer[:correctness]).to be_present
          expect(answer[:feedback_html]).to be_present
        end
      end

      it "shows solutions for published exercises if the requestor is allowed to edit it" do
        api_get api_exercise_url(@exercise.uid), @user_1_token
        expect(response).to have_http_status(:ok)

        expect(response.body_as_hash[:questions].first[:collaborator_solutions]).not_to be_empty
        response.body_as_hash[:questions].first[:answers].each do |answer|
          expect(answer[:correctness]).to be_present
          expect(answer[:feedback_html]).to be_present
        end
      end

      it "hides solutions for published exercises if the requestor is not allowed to edit it" do
        @exercise.publication.authors.destroy_all
        @exercise.publication.copyright_holders.destroy_all
        @exercise.publication.authors << FactoryBot.create(
          :author, user: @user_2, publication: @exercise.publication
        )
        @exercise.publication.copyright_holders << FactoryBot.create(
          :copyright_holder, user: @user_2, publication: @exercise.publication
        )

        api_get api_exercise_url(@exercise.uid), @user_1_token
        expect(response).to have_http_status(:ok)

        expect(response.body_as_hash[:questions].first['collaborator_solutions']).to be_nil
        response.body_as_hash[:questions].first[:answers].each do |answer|
          expect(answer[:correctness]).to be_nil
          expect(answer[:feedback_html]).to be_nil
        end
      end

      it "includes versions of the exercise" do
        api_get api_exercise_url(@exercise.uid), @user_1_token
        expect(response).to have_http_status(:ok)
        expect(response.body_as_hash[:versions]).to(
          eq([@exercise_2.version, @exercise_1.version, @exercise.version])
        )
      end
    end
  end

  context "POST /api/exercises" do
    before(:all) do
      DatabaseCleaner.start

      Exercise.where(id: @exercise.id).destroy_all
      PublicationGroup.where(id: @exercise.publication.publication_group_id).delete_all
    end
    after(:all) { DatabaseCleaner.clean }

    before { Rails.cache.clear }

    it "creates the requested Exercise and assigns the user as author and copyright holder" do
      expect do
        api_post api_exercises_url, @user_1_token, params: Api::V1::Exercises::Representer.new(
          @exercise
        ).to_json(user_options: { user: @user_1 })
      end.to change { Exercise.count }.by(1)
      expect(response).to have_http_status(:created)

      new_exercise = Exercise.order(:created_at).last
      expect(new_exercise.nickname).to eq 'MyExercise'
      expect(new_exercise.title).to eq @exercise.title
      expect(new_exercise.stimulus).to eq @exercise.stimulus
      expect(new_exercise.solutions_are_public).to eq @exercise.solutions_are_public

      expect(new_exercise.questions.first.stimulus)
        .to eq @exercise.questions.first.stimulus

      expect(new_exercise.questions.first.stems.first.content).to eq(
        @exercise.questions.first.stems.first.content)

      db_answers = new_exercise.questions.first.answers
      json_answers = @exercise.questions.first.answers
      expect(Set.new db_answers.map(&:content)).to eq(Set.new json_answers.map(&:content))

      expect(new_exercise.questions.first.collaborator_solutions).to be_empty

      expect(new_exercise.authors.first.user).to eq @user_1
      expect(new_exercise.copyright_holders.first.user).to eq @user_1
    end

    it "assigns the author and copyright holder through delegations" do
      user_3 = FactoryBot.create :user, :agreed_to_terms
      FactoryBot.create :delegation, delegator: @user_2,
                                     delegate: @user_1,
                                     can_assign_authorship: true,
                                     can_assign_copyright: false
      FactoryBot.create :delegation, delegator: user_3,
                                     delegate: @user_1,
                                     can_assign_authorship: false,
                                     can_assign_copyright: true

      expect do
        api_post api_exercises_url, @user_1_token, params: Api::V1::Exercises::Representer.new(
          @exercise
        ).to_json(user_options: { user: @user_1 })
      end.to change { Exercise.count }.by(1)
      expect(response).to have_http_status(:created)

      new_exercise = Exercise.order(:created_at).last

      authors = new_exercise.authors.map(&:user)
      expect(authors).to include(@user_1)
      expect(authors).to include(@user_2)
      expect(authors).not_to include(user_3)

      copyright_holders = new_exercise.copyright_holders.map(&:user)
      expect(copyright_holders).to include(@user_1)
      expect(copyright_holders).not_to include(@user_2)
      expect(copyright_holders).to include(user_3)
    end

    it "creates the exercise with a collaborator solution" do
      exercise = FactoryBot.build(:exercise, collaborator_solutions_count: 1)
      exercise.publication.authors << FactoryBot.build(
        :author, user: @user_1, publication: @exercise.publication
      )
      exercise.publication.copyright_holders << FactoryBot.build(
        :copyright_holder, user: @user_1, publication: @exercise.publication
      )

      expect do
        api_post api_exercises_url, @user_1_token, params: Api::V1::Exercises::Representer.new(
          exercise
        ).to_json(user_options: { user: @user_1 })
      end.to change { Exercise.count }.by(1)
      expect(response).to have_http_status(:created)

      new_exercise = Exercise.order(:created_at).last

      db_solutions = new_exercise.questions.first.collaborator_solutions
      json_solutions = @exercise.questions.first.collaborator_solutions

      expect(Set.new db_solutions.map(&:content)).to eq(Set.new json_solutions.map(&:content))
    end

    it "fails if the nickname has already been taken" do
      FactoryBot.create :publication_group, nickname: 'MyExercise'

      expect do
        api_post api_exercises_url, @user_1_token, params: Api::V1::Exercises::Representer.new(
          @exercise
        ).to_json(user_options: { user: @user_1 })
      end.not_to change { Exercise.count }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body_as_hash[:errors].first[:code]).to eq 'nickname_has_already_been_taken'
    end

  end

  context "PATCH /api/exercises/:id" do
    before { @old_attributes = @exercise.reload.attributes }

    let(:new_solutions_are_public) { !@exercise.solutions_are_public }

    it "updates the requested Exercise" do
      api_patch api_exercise_url(@exercise.uid), @user_1_token, params: {
        nickname: 'MyExercise', title: "Ipsum lorem", solutions_are_public: new_solutions_are_public
      }.to_json
      expect(response).to have_http_status(:ok)
      @exercise.reload
      new_attributes = @exercise.attributes

      expect(@exercise.nickname).to eq 'MyExercise'
      expect(@exercise.title).to eq "Ipsum lorem"
      expect(@exercise.solutions_are_public).to eq new_solutions_are_public
      expect(new_attributes.except('title', 'updated_at', 'solutions_are_public'))
        .to eq(@old_attributes.except('title', 'updated_at', 'solutions_are_public'))
    end

    it "fails if the exercise is published and \"@draft\" was not requested" do
      @exercise.publication.publish.save!

      expect do
        api_patch api_exercise_url(@exercise.uid), @user_1_token, params: {
          nickname: 'MyExercise', title: "Ipsum lorem"
        }.to_json
      end.to raise_error(SecurityTransgression)
      @exercise.reload

      expect(@exercise.attributes.except('updated_at')).to eq @old_attributes.except('updated_at')
    end

    it "fails if the nickname has already been taken" do
      FactoryBot.create :publication_group, nickname: 'MyExercise2'

      api_patch api_exercise_url(@exercise.uid), @user_1_token, params: {
        nickname: 'MyExercise2', title: "Ipsum lorem"
      }.to_json

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
      api_patch api_exercise_url(id), @user_1_token, params: {
        nickname: 'MyExercise', title: "Ipsum lorem"
      }.to_json
      expect(response).to have_http_status(:ok)
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
        api_patch api_exercise_url(id), @user_1_token, params: {
          nickname: 'MyExercise', title: "Ipsum lorem"
        }.to_json
      end.to change{ Exercise.count }.by(1)
      expect(response).to have_http_status(:ok)
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

  context "DELETE /api/exercises/:id" do
    it "deletes the requested draft Exercise" do
      expect do
        api_delete api_exercise_url(@exercise.uid), @user_1_token
      end.to change(Exercise, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(Exercise.where(id: @exercise.id)).not_to exist
    end
  end
end
