require "rails_helper"

module Api::V1
  RSpec.describe VocabTermsController, type: :controller, api: true, version: :v1 do
    before(:all) do
      DatabaseCleaner.start

      application = FactoryBot.create :doorkeeper_application
      @user = FactoryBot.create :user, :agreed_to_terms
      admin = FactoryBot.create :user, :administrator, :agreed_to_terms
      @application_token = FactoryBot.create :doorkeeper_access_token,
                                             application: application,
                                             resource_owner_id: nil
      @user_token = FactoryBot.create :doorkeeper_access_token,
                                      application: application,
                                      resource_owner_id: @user.id
      FactoryBot.create :doorkeeper_access_token,
                        application: application,
                        resource_owner_id: admin.id

      @vocab_term = FactoryBot.build(:vocab_term)
      @vocab_term.publication.authors << FactoryBot.build(
        :author, user: @user, publication: @vocab_term.publication
      )
      @vocab_term.publication.copyright_holders << FactoryBot.build(
        :copyright_holder, user: @user, publication: @vocab_term.publication
      )
      @vocab_term.nickname = 'MyVocab'
      @vocab_term.save!
    end
    after(:all) { DatabaseCleaner.clean }

    [ :get, :post ].each do |method|
      context "#{method.to_s.upcase} index" do
        before(:all) do
          DatabaseCleaner.start

          10.times do
            vt = FactoryBot.create(:vocab_term, :published)
            vt.publication.authors << Author.new(publication: vt.publication, user: @user)
            vt.publication.copyright_holders << CopyrightHolder.new(publication: vt.publication, user: @user)
          end

          tested_strings = ["%lorem ipsu%", "%adipiscing elit%", "draft"]
          VocabTerm.where(VocabTerm.arel_table[:name].matches_any(tested_strings).or(
                          VocabTerm.arel_table[:definition].matches_any(tested_strings))).delete_all

          @vocab_term_1 = FactoryBot.build(:vocab_term, :published)
          Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
            @vocab_term_1
          ).from_hash(
            'tags' => ['tag1', 'tag2'],
            'term' => "Lorem ipsum",
            'definition' => "Dolor sit amet",
            'distractor_literals' => ["Consectetur adipiscing elit", "Sed do eiusmod tempor"]
          )
          @vocab_term_1.publication.authors << Author.new(publication: @vocab_term_1.publication, user: @user)
          @vocab_term_1.publication.copyright_holders << CopyrightHolder.new(publication: @vocab_term_1.publication, user: @user)
          @vocab_term_1.save!

          @vocab_term_2 = FactoryBot.build(:vocab_term, :published)
          Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
            @vocab_term_2
          ).from_hash(
            'tags' => ['tag2', 'tag3'],
            'term' => "Dolorem ipsum",
            'definition' => "Quia dolor sit amet",
            'distractor_literals' => ["Consectetur adipisci velit", "Sed quia non numquam"]
          )
          @vocab_term_2.publication.authors << Author.new(publication: @vocab_term_2.publication, user: @user)
          @vocab_term_2.publication.copyright_holders << CopyrightHolder.new(publication: @vocab_term_2.publication, user: @user)
          @vocab_term_2.save!

          @vocab_term_draft = FactoryBot.build(:vocab_term)
          Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
            @vocab_term_draft
          ).from_hash(
            'tags' => ['all', 'the', 'tags'],
            'term' => "draft",
            'definition' => "Not ready for prime time",
            'distractor_literals' => ["Release to production NOW"]
          )
          @vocab_term_draft.publication.authors << Author.new(publication: @vocab_term_draft.publication, user: @user)
          @vocab_term_draft.publication.copyright_holders << CopyrightHolder.new(publication: @vocab_term_draft.publication, user: @user)
          @vocab_term_draft.save!
        end
        after(:all) { DatabaseCleaner.clean }

        before { request.env['HTTP_AUTHORIZATION'] = "Bearer #{@user_token.token}" }

        context "no matches" do
          it "does not return drafts that the user is not allowed to see" do
            send method, :index, params: { q: 'content:draft', format: :json }
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
            @vocab_term_draft.publication.authors << Author.new(user: @user)
            @vocab_term_draft.publication.copyright_holders << CopyrightHolder.new(user: @user)
            @vocab_term_draft.reload
            @user.reload
            send method, :index, params: { q: 'content:draft', format: :json }
            expect(response).to have_http_status(:success)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @vocab_term_draft.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns a VocabTerm matching the content" do
            send method, :index, params: { q: 'content:"oLoReM iPsU"', format: :json }
            expect(response).to have_http_status(:success)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @vocab_term_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns a VocabTerm matching the tags" do
            send method, :index, params: { q: 'tag:tAg1', format: :json }
            expect(response).to have_http_status(:success)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @vocab_term_1.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end
        end

        context "multiple matches" do
          it "returns VocabTerms matching the content" do
            send method, :index, params: { q: 'content:"lOrEm IpSuM"', format: :json }
            expect(response).to have_http_status(:success)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @vocab_term_1.uuid),
                      a_hash_including(uuid: @vocab_term_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns VocabTerms matching the tags" do
            send method, :index, params: { q: 'tag:TaG2', format: :json }
            expect(response).to have_http_status(:success)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @vocab_term_1.uuid),
                      a_hash_including(uuid: @vocab_term_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "sorts by multiple fields in different directions" do
            send method, :index, params: {q: 'content:"lOrEm IpSuM"', order_by: "number DESC, version ASC",
                                 format: :json }
            expect(response).to have_http_status(:success)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @vocab_term_2.uuid),
                      a_hash_including(uuid: @vocab_term_1.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end
        end
      end
    end

    context "GET show" do
      before(:all) do
        DatabaseCleaner.start

        @vocab_term.publication.publish.save!

        @vocab_term_2 = @vocab_term.new_version
        @vocab_term_2.save!
      end
      after(:all) { DatabaseCleaner.clean }

      it "returns the VocabTerm requested by group_uuid and version" do
        api_get :show, @user_token, params: {
          id: "#{@vocab_term.group_uuid}@#{@vocab_term.version}"
        }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
      end

      it "returns the VocabTerm requested by uuid" do
        api_get :show, @user_token, params: { id: @vocab_term.uuid }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
      end

      it "returns the VocabTerm requested by uid" do
        api_get :show, @user_token, params: { id: @vocab_term.uid }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
      end

      it "returns the latest published VocabTerm if only the group_uuid is specified" do
        api_get :show, @user_token, params: { id: @vocab_term.group_uuid }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
      end

      it "returns the latest published VocabTerm if only the number is specified" do
        api_get :show, @user_token, params: { id: @vocab_term.number }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
      end

      it "returns the latest draft VocabTerm if \"group_uuid@draft\" is requested" do
        api_get :show, @user_token, params: { id: "#{@vocab_term.group_uuid}@draft" }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term_2.uuid))
      end

      it "returns the latest draft VocabTerm if \"number@draft\" is requested" do
        api_get :show, @user_token, params: { id: "#{@vocab_term.number}@draft" }
        expect(response).to have_http_status(:success)
        expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term_2.uuid))
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @vocab_term_2.destroy

        expect do
          api_get :show, @user_token, params: { id: "#{@vocab_term.number}@draft" }
        end.to change{ VocabTerm.count }.by(1)
        expect(response).to have_http_status(:success)

        new_vocab_term = VocabTerm.order(:created_at).last
        expect(new_vocab_term.id).not_to eq @vocab_term.id
        expect(new_vocab_term.number).to eq @vocab_term.number
        expect(new_vocab_term.version).to eq @vocab_term.version + 1

        expect(new_vocab_term.attributes.except('id', 'created_at', 'updated_at'))
          .to eq(@vocab_term.attributes.except('id', 'created_at', 'updated_at'))
      end
    end

    context "POST create" do
      before(:all) do
        DatabaseCleaner.start

        PublicationGroup.where(id: @vocab_term.publication.publication_group_id).delete_all
        Publication.where(id: @vocab_term.publication.id).delete_all
        VocabTerm.where(id: @vocab_term.id).delete_all
      end
      after(:all) { DatabaseCleaner.clean }

      before { Rails.cache.clear }

      it "creates the requested VocabTerm and assigns the user as author and CR holder" do
        expect do
          api_post :create, @user_token,
                   body: Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
                     @vocab_term
                   ).to_hash(user_options: { user: @user })
        end.to change { VocabTerm.count }.by(1)
        expect(response).to have_http_status(:success)

        new_vocab_term = VocabTerm.last
        expect(new_vocab_term.nickname).to eq 'MyVocab'
        expect(new_vocab_term.name).to eq @vocab_term.name
        expect(new_vocab_term.definition).to eq @vocab_term.definition

        expect(new_vocab_term.authors.first.user).to eq @user
        expect(new_vocab_term.copyright_holders.first.user).to eq @user
      end

      it "fails if the nickname has already been taken" do
        FactoryBot.create :publication_group, nickname: 'MyVocab'

        expect do
          api_post :create, @user_token,
                   body: Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
                     @vocab_term
                   ).to_hash(user_options: { user: @user })
        end.not_to change { VocabTerm.count }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body_as_hash[:errors].first[:code]).to eq 'nickname_has_already_been_taken'
      end
    end

    context "PATCH update" do
      before { @old_attributes = @vocab_term.reload.attributes }

      it "updates the requested VocabTerm" do
        api_patch :update, @user_token, params: { id: @vocab_term.uid },
                                        body: { nickname: 'MyVocab', term: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @vocab_term.reload
        new_attributes = @vocab_term.attributes

        expect(@vocab_term.nickname).to eq 'MyVocab'
        expect(@vocab_term.name).to eq "Ipsum lorem"
        expect(new_attributes.except('name', 'updated_at'))
          .to eq(@old_attributes.except('name', 'updated_at'))
      end

      it "fails if the vocab_term is published and \"@draft\" was not requested" do
        @vocab_term.publication.publish.save!

        expect do
          api_patch :update, @user_token, params: { id: @vocab_term.uid }, body: {
            nickname: 'MyVocab', term: "Ipsum lorem"
          }
        end.to raise_error(SecurityTransgression)

        @vocab_term.reload
        expect(@vocab_term.attributes.except('updated_at')).to(
          eq @old_attributes.except('updated_at')
        )
      end

      it "fails if the nickname has already been taken" do
        FactoryBot.create :publication_group, nickname: 'MyVocab2'

        api_patch :update, @user_token, params: { id: @vocab_term.uid }, body: {
          nickname: 'MyVocab2', title: "Ipsum lorem"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body_as_hash[:errors].first[:code]).to eq 'nickname_has_already_been_taken'

        @vocab_term.reload
        expect(@vocab_term.attributes.except('updated_at')).to(
          eq @old_attributes.except('updated_at')
        )
      end

      it "updates the latest draft VocabTerm if \"@draft\" is requested" do
        @vocab_term.publication.publish.save!
        vocab_term_2 = @vocab_term.new_version
        vocab_term_2.save!
        vocab_term_2.reload

        api_patch :update, @user_token, params: { id: "#{@vocab_term.number}@draft" },
                                        body: { nickname: 'MyVocab', term: "Ipsum lorem" }
        expect(response).to have_http_status(:success)
        @vocab_term.reload

        expect(@vocab_term.attributes.except('updated_at')).to(
          eq @old_attributes.except('updated_at')
        )

        uid = response.body_as_hash[:uid]
        new_vocab_term = VocabTerm.with_id(uid).first
        new_attributes = new_vocab_term.attributes

        expect(new_vocab_term.nickname).to eq 'MyVocab'
        expect(new_vocab_term.name).to eq "Ipsum lorem"
        expect(new_attributes.except('name', 'updated_at'))
          .to eq(vocab_term_2.attributes.except('name', 'updated_at'))
      end

      it "creates a new draft version if no draft and \"@draft\" is requested" do
        @vocab_term.publication.publish.save!

        expect do
          api_patch :update, @user_token, params: { id: "#{@vocab_term.number}@draft" },
                                          body: {
                                            nickname: 'MyVocab', term: "Ipsum lorem"
                                          }
        end.to change{ VocabTerm.count }.by(1)
        expect(response).to have_http_status(:success)
        @vocab_term.reload

        expect(@vocab_term.attributes.except('updated_at')).to(
          eq @old_attributes.except('updated_at')
        )

        uid = response.body_as_hash[:uid]
        new_vocab_term = VocabTerm.with_id(uid).first
        new_attributes = new_vocab_term.attributes

        expect(new_vocab_term.id).not_to eq @vocab_term.id
        expect(new_vocab_term.number).to eq @vocab_term.number
        expect(new_vocab_term.version).to eq @vocab_term.version + 1
        expect(new_vocab_term.nickname).to eq "MyVocab"
        expect(new_vocab_term.name).to eq "Ipsum lorem"
        expect(new_attributes.except('id', 'name', 'created_at', 'updated_at'))
          .to eq(@old_attributes.except('id', 'name', 'created_at', 'updated_at'))
      end
    end

    context "DELETE destroy" do
      it "deletes the requested draft VocabTerm" do
        expect do
          api_delete :destroy, @user_token, params: { id: @vocab_term.uid }
        end.to change(VocabTerm, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(VocabTerm.where(id: @vocab_term.id)).not_to exist
      end
    end
  end
end
