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
        10.times { FactoryGirl.create(:vocab_term, :published) }

        ad = "%adipisci%"
        VocabTerm.joins{questions.outer.stems.outer}
                 .joins{questions.outer.answers.outer}
                 .where{(title.like ad) |\
                        (stimulus.like ad) |\
                        (questions.stimulus.like ad) |\
                        (stems.content.like ad) |\
                        (answers.content.like ad)}.delete_all

        @vocab_term_1 = FactoryGirl.build(:vocab_term, :published)
        Api::V1::VocabTermRepresenter.new(@vocab_term_1).from_json({
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
        @vocab_term_1.save!

        @vocab_term_2 = FactoryGirl.build(:vocab_term, :published)
        Api::V1::VocabTermRepresenter.new(@vocab_term_2).from_json({
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
        @vocab_term_2.save!

        @vocab_term_draft = FactoryGirl.build(:vocab_term)
        Api::V1::VocabTermRepresenter.new(@vocab_term_draft).from_json({
          tags: ['all', 'the', 'tags'],
          title: "DRAFT",
          stimulus: "This is a draft",
          questions: [{
            stimulus: "with no collaborators",
            stem_html: "and should not appear",
            answers: [{
              content_html: "in most searches"
            }]
          }]
        }.to_json)
        @vocab_term_draft.save!
      end

      context "no matches" do
        it "does not return drafts that the user is not allowed to see" do
          api_get :index, user_token, parameters: {q: 'content:draft'}
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
          api_get :index, user_token, parameters: {q: 'content:aDiPiScInG eLiT'}
          expect(response).to have_http_status(:success)

          expected_response = {
            total_count: 1,
            items: [Api::V1::VocabTermRepresenter.new(@vocab_term_1)]
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
          api_get :index, user_token, parameters: {q: 'content:AdIpIsCi'}
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
          api_get :index, user_token, parameters: {q: 'content:aDiPiScI',
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

        expected_response = Api::V1::VocabTermRepresenter.new(@vocab_term).to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "returns the latest published VocabTerm if no version is specified" do
        api_get :show, user_token, parameters: { id: @vocab_term.number }
        expect(response).to have_http_status(:success)

        expected_response = Api::V1::VocabTermRepresenter.new(@vocab_term).to_json(user: user)
        expect(response.body).to eq(expected_response)
      end

      it "returns the latest draft VocabTerm if \"@draft\" is requested" do
        api_get :show, user_token, parameters: { id: "#{@vocab_term.number}@draft" }
        expect(response).to have_http_status(:success)

        expected_response = Api::V1::VocabTermRepresenter.new(@vocab_term_2.reload)
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

      context 'with solutions' do
        before(:each) do
          question = @vocab_term.questions.first
          question.collaborator_solutions << FactoryGirl.create(:collaborator_solution, question: question)
        end

        it "shows solutions for published vocab_terms if the requestor is an app" do
          api_get :show, application_token, parameters: { id: @vocab_term.uid }
          expect(response).to have_http_status(:success)

          response_hash = JSON.parse(response.body)
          expect(response_hash['questions'].first['collaborator_solutions']).not_to be_empty
          response_hash['questions'].first['answers'].each do |answer|
            expect(answer['correctness']).to be_present
            expect(answer['feedback_html']).to be_present
          end
        end

        it "shows solutions for published vocab_terms if the requestor is allowed to edit it" do
          api_get :show, user_token, parameters: { id: @vocab_term.uid }
          expect(response).to have_http_status(:success)

          response_hash = JSON.parse(response.body)
          expect(response_hash['questions'].first['collaborator_solutions']).not_to be_empty
          response_hash['questions'].first['answers'].each do |answer|
            expect(answer['correctness']).to be_present
            expect(answer['feedback_html']).to be_present
          end
        end

        it "hides solutions for published vocab_terms if the requestor is not allowed to edit it" do
          @vocab_term.publication.editors.destroy_all

          api_get :show, user_token, parameters: { id: @vocab_term.uid }
          expect(response).to have_http_status(:success)

          response_hash = JSON.parse(response.body)
          expect(response_hash['questions'].first['collaborator_solutions']).to be_nil
          response_hash['questions'].first['answers'].each do |answer|
            expect(answer['correctness']).to be_nil
            expect(answer['feedback_html']).to be_nil
          end
        end

      end

    end

    describe "POST create" do

      it "creates the requested VocabTerm and assigns the user as author and CR holder" do
        expect { api_post :create, user_token,
                          raw_post_data: Api::V1::VocabTermRepresenter.new(
                                           @vocab_term
                                         ).to_json(user: user)
        }.to change(VocabTerm, :count).by(1)
        expect(response).to have_http_status(:success)

        new_vocab_term = VocabTerm.last
        expect(new_vocab_term.title).to eq @vocab_term.title
        expect(new_vocab_term.stimulus).to eq @vocab_term.stimulus

        expect(new_vocab_term.questions.first.stimulus)
          .to eq @vocab_term.questions.first.stimulus

        expect(new_vocab_term.questions.first.stems.first.content).to eq(
          @vocab_term.questions.first.stems.first.content)

        db_answers = new_vocab_term.questions.first.answers
        json_answers = @vocab_term.questions.first.answers
        expect(Set.new db_answers.collect { |answer| answer.content }).to(
          eq(Set.new json_answers.collect { |answer| answer.content })
        )

        db_solutions = new_vocab_term.questions.first.collaborator_solutions
        json_solutions = @vocab_term.questions.first.collaborator_solutions

        expect(Set.new db_solutions.collect { |solution| solution.content }).to(
          eq(Set.new json_solutions.collect { |solution| solution.content })
        )

        expect(new_vocab_term.authors.first.user).to eq user
        expect(new_vocab_term.copyright_holders.first.user).to eq user
      end

      it "creates the vocab_term with a collaborator solution" do
        vocab_term = FactoryGirl.build(:vocab_term, collaborator_solutions_count: 1)
        vocab_term.publication.editors << FactoryGirl.build(
          :editor, user: user, publication: @vocab_term.publication
        )

        expect { api_post :create, user_token,
                          raw_post_data: Api::V1::VocabTermRepresenter.new(vocab_term).to_json(user: user)
        }.to change(VocabTerm, :count).by(1)
        expect(response).to have_http_status(:success)

        new_vocab_term = VocabTerm.last

        expect(new_vocab_term.questions.first.collaborator_solutions).not_to be_empty
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
                                       raw_post_data: { title: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @vocab_term.reload
        new_attributes = @vocab_term.attributes

        expect(@vocab_term.title).to eq "Ipsum lorem"
        expect(new_attributes.except('title', 'updated_at'))
          .to eq(@old_attributes.except('title', 'updated_at'))
      end

      it "fails if the vocab_term is published and \"@draft\" was not requested" do
        @vocab_term.publication.publish.save!

        expect{ api_patch :update, user_token, parameters: { id: @vocab_term.uid },
                                               raw_post_data: { title: "Ipsum lorem" } }.to(
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
                                       raw_post_data: { title: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @vocab_term.reload

        expect(@vocab_term.attributes).to eq @old_attributes

        uid = JSON.parse(response.body)['uid']
        new_vocab_term = VocabTerm.with_uid(uid).first
        new_attributes = new_vocab_term.attributes

        expect(new_vocab_term.title).to eq "Ipsum lorem"
        expect(new_attributes.except('title', 'updated_at'))
          .to eq(vocab_term_2.attributes.except('title', 'updated_at'))
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @vocab_term.publication.publish.save!

        expect{
          api_patch :update, user_token, parameters: { id: "#{@vocab_term.number}@draft" },
                                         raw_post_data: { title: "Ipsum lorem" } }.to(
          change{ VocabTerm.count }.by(1)
        )
        expect(response).to have_http_status(:success)
        @vocab_term.reload

        expect(@vocab_term.attributes).to eq @old_attributes

        uid = JSON.parse(response.body)['uid']
        new_vocab_term = VocabTerm.with_uid(uid).first
        new_attributes = new_vocab_term.attributes

        expect(new_vocab_term.id).not_to eq @vocab_term.id
        expect(new_vocab_term.number).to eq @vocab_term.number
        expect(new_vocab_term.version).to eq @vocab_term.version + 1
        expect(new_vocab_term.title).to eq "Ipsum lorem"
        expect(new_attributes.except('id', 'uid', 'title', 'created_at', 'updated_at'))
          .to eq(@old_attributes.except('id', 'uid', 'title', 'created_at', 'updated_at'))
      end

    end

    describe "DELETE destroy" do

      it "deletes the requested draft VocabTerm" do
        @vocab_term.save!
        expect{ api_delete :destroy, user_token,
                           parameters: { id: @vocab_term.uid }
        }.to change(VocabTerm, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(VocabTerm.where(id: @vocab_term.id)).not_to exist
      end

    end

  end
end
