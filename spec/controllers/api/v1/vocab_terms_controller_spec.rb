require "rails_helper"

module Api::V1
  describe VocabTermsController, type: :controller, api: true, version: :v1 do

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
      @vocab_term = FactoryGirl.build(:vocab_term)
      @vocab_term.publication.editors << FactoryGirl.build(
        :editor, user: user, publication: @vocab_term.publication
      )
    end

    describe "GET index" do

      before(:each) do
        10.times do
          vt = FactoryGirl.create(:vocab_term, :published)
          vt.publication.authors << Author.new(publication: vt.publication, user: user)
        end

        tested_strings = ["%lorem ipsu%", "%adipiscing elit%", "draft"]
        VocabTerm.where{(name.like_any tested_strings) |
                        (definition.like_any tested_strings)}.delete_all

        @vocab_term_1 = FactoryGirl.build(:vocab_term, :published)
        Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_1).from_json({
          tags: ['tag1', 'tag2'],
          term: "Lorem ipsum",
          definition: "Dolor sit amet",
          distractor_literals: ["Consectetur adipiscing elit", "Sed do eiusmod tempor"]
        }.to_json)
        @vocab_term_1.save!

        @vocab_term_2 = FactoryGirl.build(:vocab_term, :published)
        Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_2).from_json({
          tags: ['tag2', 'tag3'],
          term: "Dolorem ipsum",
          definition: "Quia dolor sit amet",
          distractor_literals: ["Consectetur adipisci velit", "Sed quia non numquam"]
        }.to_json)
        @vocab_term_2.save!

        @vocab_term_draft = FactoryGirl.build(:vocab_term)
        Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_draft)
                                                                  .from_json({
          tags: ['all', 'the', 'tags'],
          term: "draft",
          definition: "Not ready for prime time",
          distractor_literals: ["Release to production NOW"]
        }.to_json)
        @vocab_term_draft.save!
      end

      context "no matches" do
        it "does not return drafts that the user is not allowed to see" do
          api_get :index, nil, parameters: {q: 'content:draft'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 0,
            items: []
          }.to_json

          expect(response.body).to eq(expected_response)
        end
      end

      context "single match" do
        it "returns drafts that the user is allowed to see" do
          @vocab_term_draft.publication.authors << Author.new(user: user)
          @vocab_term_draft.reload
          user.reload
          api_get :index, user_token, parameters: {q: 'content:draft'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [Api::V1::VocabTermRepresenter.new(@vocab_term_draft).to_hash(user: user)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end

        it "returns a VocabTerm matching the content" do
          api_get :index, user_token, parameters: {q: 'content:"oLoReM iPsU"'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [Api::V1::VocabTermRepresenter.new(@vocab_term_2)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end

        it "returns a VocabTerm matching the tags" do
          api_get :index, user_token, parameters: {q: 'tag:tAg1'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [Api::V1::VocabTermRepresenter.new(@vocab_term_1)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end
      end

      context "multiple matches" do
        it "returns VocabTerms matching the content" do
          api_get :index, user_token, parameters: {q: 'content:"lOrEm IpSuM"'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 2,
            items: [Api::V1::VocabTermRepresenter.new(@vocab_term_1),
                    Api::V1::VocabTermRepresenter.new(@vocab_term_2)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end

        it "returns VocabTerms matching the tags" do
          api_get :index, user_token, parameters: {q: 'tag:TaG2'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 2,
            items: [Api::V1::VocabTermRepresenter.new(@vocab_term_1),
                    Api::V1::VocabTermRepresenter.new(@vocab_term_2)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end

        it "sorts by multiple fields in different directions" do
          api_get :index, user_token, parameters: {q: 'content:"lOrEm IpSuM"',
                                                   order_by: "number DESC, version ASC"}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 2,
            items: [Api::V1::VocabTermRepresenter.new(@vocab_term_2),
                    Api::V1::VocabTermRepresenter.new(@vocab_term_1)]
          }.to_json

          expect(response.body).to eq(expected_response)
        end
      end

    end

    describe "GET show" do

      before(:each) do
        @vocab_term.publication.publish
        @vocab_term.save!
        @vocab_term.reload

        @vocab_term_2 = @vocab_term.new_version
        @vocab_term_2.save!
      end

      it "returns the VocabTerm requested by uid" do
        api_get :show, user_token, parameters: { id: @vocab_term.uid }
        expect(response).to have_http_status(:success)

        expected_response = \
          Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term)
                                                                    .to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "returns the latest published VocabTerm if no version is specified" do
        api_get :show, user_token, parameters: { id: @vocab_term.number }
        expect(response).to have_http_status(:success)

        expected_response = \
          Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term)
                                                                    .to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "returns the latest draft VocabTerm if \"@draft\" is requested" do
        api_get :show, user_token, parameters: { id: "#{@vocab_term.number}@draft" }
        expect(response).to have_http_status(:success)

        expected_response = \
          Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(@vocab_term_2.reload)
                                                                    .to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @vocab_term_2.destroy

        expect{ api_get :show, user_token, parameters: { id: "#{@vocab_term.number}@draft" } }.to(
          change{ VocabTerm.count }.by(1)
        )
        expect(response).to have_http_status(:success)

        new_vocab_term = VocabTerm.order(:created_at).last
        expect(new_vocab_term.id).not_to eq @vocab_term.id
        expect(new_vocab_term.number).to eq @vocab_term.number
        expect(new_vocab_term.version).to eq @vocab_term.version + 1

        expect(new_vocab_term.attributes.except('id', 'uid', 'created_at', 'updated_at'))
          .to eq(@vocab_term.attributes.except('id', 'uid', 'created_at', 'updated_at'))
      end

    end

    describe "POST create" do

      before(:each) do
        @vocab_term.vocab_distractors.each do |vd|
          vd.distractor_term.save!
          vd.distractor_term_number = vd.distractor_term.publication.number
        end
      end

      it "creates the requested VocabTerm and assigns the user as author and CR holder" do
        expect {
          api_post :create, user_token,
                   raw_post_data: Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter.new(
                     @vocab_term
                   ).to_json(user: user)
        }.to change(VocabTerm, :count).by(1)
        expect(response).to have_http_status(:success)

        new_vocab_term = VocabTerm.last
        expect(new_vocab_term.name).to eq @vocab_term.name
        expect(new_vocab_term.definition).to eq @vocab_term.definition

        expect(new_vocab_term.authors.first.user).to eq user
        expect(new_vocab_term.copyright_holders.first.user).to eq user
      end
    end

    describe "PATCH update" do

      before(:each) do
        @vocab_term.save!
        @vocab_term.reload
        @old_attributes = @vocab_term.attributes
      end

      it "updates the requested VocabTerm" do
        api_patch :update, user_token, parameters: { id: @vocab_term.uid },
                                       raw_post_data: { term: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @vocab_term.reload
        new_attributes = @vocab_term.attributes

        expect(@vocab_term.name).to eq "Ipsum lorem"
        expect(new_attributes.except('name', 'updated_at'))
          .to eq(@old_attributes.except('name', 'updated_at'))
      end

      it "fails if the vocab_term is published and \"@draft\" was not requested" do
        @vocab_term.publication.publish.save!

        expect{ api_patch :update, user_token, parameters: { id: @vocab_term.uid },
                                               raw_post_data: { term: "Ipsum lorem" } }.to(
          raise_error(SecurityTransgression)
        )
        @vocab_term.reload

        expect(@vocab_term.attributes).to eq @old_attributes
      end

      it "updates the latest draft VocabTerm if \"@draft\" is requested" do
        @vocab_term.publication.publish.save!
        vocab_term_2 = @vocab_term.new_version
        vocab_term_2.save!
        vocab_term_2.reload

        api_patch :update, user_token, parameters: { id: "#{@vocab_term.number}@draft" },
                                       raw_post_data: { term: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @vocab_term.reload

        expect(@vocab_term.attributes).to eq @old_attributes

        uid = JSON.parse(response.body)['uid']
        new_vocab_term = VocabTerm.with_id(uid).first
        new_attributes = new_vocab_term.attributes

        expect(new_vocab_term.name).to eq "Ipsum lorem"
        expect(new_attributes.except('name', 'updated_at'))
          .to eq(vocab_term_2.attributes.except('name', 'updated_at'))
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @vocab_term.publication.publish.save!

        expect{
          api_patch :update, user_token, parameters: { id: "#{@vocab_term.number}@draft" },
                                         raw_post_data: { term: "Ipsum lorem" } }.to(
          change{ VocabTerm.count }.by(1)
        )
        expect(response).to have_http_status(:success)
        @vocab_term.reload

        expect(@vocab_term.attributes).to eq @old_attributes

        uid = JSON.parse(response.body)['uid']
        new_vocab_term = VocabTerm.with_id(uid).first
        new_attributes = new_vocab_term.attributes

        expect(new_vocab_term.id).not_to eq @vocab_term.id
        expect(new_vocab_term.number).to eq @vocab_term.number
        expect(new_vocab_term.version).to eq @vocab_term.version + 1
        expect(new_vocab_term.name).to eq "Ipsum lorem"
        expect(new_attributes.except('id', 'uid', 'name', 'created_at', 'updated_at'))
          .to eq(@old_attributes.except('id', 'uid', 'name', 'created_at', 'updated_at'))
      end

    end

    describe "DELETE destroy" do

      it "deletes the requested draft VocabTerm" do
        @vocab_term.save!
        expect{ api_delete :destroy, user_token, parameters: { id: @vocab_term.uid }
        }.to change(VocabTerm, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(VocabTerm.where(id: @vocab_term.id)).not_to exist
      end

    end

  end
end
