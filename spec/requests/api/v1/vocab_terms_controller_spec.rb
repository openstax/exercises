require 'rails_helper'

RSpec.describe Api::V1::VocabTermsController, type: :request, api: true, version: :v1 do
  before(:all) do
    DatabaseCleaner.start

    application = FactoryBot.create :doorkeeper_application
    @user_1 = FactoryBot.create :user, :agreed_to_terms
    @user_2 = FactoryBot.create :user, :agreed_to_terms
    @user_3 = FactoryBot.create :user, :agreed_to_terms
    @user_draft = FactoryBot.create :user, :agreed_to_terms
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

    @vocab_term = FactoryBot.build(:vocab_term)
    @vocab_term.publication.authors << FactoryBot.build(
      :author, user: @user_1, publication: @vocab_term.publication
    )
    @vocab_term.publication.copyright_holders << FactoryBot.build(
      :copyright_holder, user: @user_1, publication: @vocab_term.publication
    )
    @vocab_term.nickname = 'MyVocab'
    @vocab_term.save!
  end
  after(:all) { DatabaseCleaner.clean }

  {
    get: { api_vocab_terms: 'vocab_terms', search_api_vocab_terms: 'vocab_terms/search' },
    post: { search_api_vocab_terms: 'vocab_terms/search' }
  }.each do |method, cases|
    cases.each do |url_method, path|
      context "#{method.to_s.upcase} /api/#{path}" do
        before(:all) do
          DatabaseCleaner.start

          10.times do
            vt = FactoryBot.create(:vocab_term, :published)
            vt.publication.authors << Author.new(publication: vt.publication, user: @user_1)
            vt.publication.copyright_holders << CopyrightHolder.new(
              publication: vt.publication, user: @user_1
            )
          end

          tested_strings = ['%lorem%', '%ipsu%', '%draft%']
          VocabTerm.where(
            VocabTerm.arel_table[:name].matches_any(tested_strings).or(
            VocabTerm.arel_table[:definition].matches_any(tested_strings))
          ).destroy_all

          @vocab_term_1 = FactoryBot.build(:vocab_term, :published)
          Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
            @vocab_term_1
          ).from_hash(
            {
              tags: ['tag1', 'tag2'],
              term: "Lorem ipsum",
              definition: "Dolor sit amet",
              distractor_literals: ["Consectetur adipiscing elit", "Sed do eiusmod tempor"]
            }.deep_stringify_keys
          )
          @vocab_term_1.publication.authors << Author.new(
            publication: @vocab_term_1.publication, user: @user_2
          )
          @vocab_term_1.publication.copyright_holders << CopyrightHolder.new(
            publication: @vocab_term_1.publication, user: @user_2
          )
          @vocab_term_1.save!

          @vocab_term_2 = FactoryBot.build(:vocab_term, :published)
          Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
            @vocab_term_2
          ).from_hash(
            {
              tags: ['tag2', 'tag3'],
              term: "Dolorem ipsum",
              definition: "Quia dolor sit amet",
              distractor_literals: ["Consectetur adipisci velit", "Sed quia non numquam"]
            }.deep_stringify_keys
          )
          @vocab_term_2.publication.authors << Author.new(
            publication: @vocab_term_2.publication, user: @user_3
          )
          @vocab_term_2.publication.copyright_holders << CopyrightHolder.new(
            publication: @vocab_term_2.publication, user: @user_3
          )
          @vocab_term_2.save!

          @vocab_term_draft = FactoryBot.build(:vocab_term)
          Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
            @vocab_term_draft
          ).from_hash(
            {
              tags: ['all', 'the', 'tags'],
              term: "draft",
              definition: "Not ready for prime time",
              distractor_literals: ["Release to production NOW"]
            }.deep_stringify_keys
          )
          @vocab_term_draft.publication.authors << Author.new(
            publication: @vocab_term_draft.publication, user: @user_draft
          )
          @vocab_term_draft.publication.copyright_holders << CopyrightHolder.new(
            publication: @vocab_term_draft.publication, user: @user_draft
          )
          @vocab_term_draft.save!
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
            @vocab_term_draft.publication.authors << Author.new(user: @user_1)
            @vocab_term_draft.publication.copyright_holders << CopyrightHolder.new(user: @user_1)
            send api_method, url_proc.call(q: 'content:draft'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @vocab_term_draft.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns a VocabTerm matching the content" do
            send api_method, url_proc.call(q: 'content:oLoReM iPsU'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @vocab_term_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns a VocabTerm matching the tags" do
            send api_method, url_proc.call(q: 'tag:tAg1'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 1,
              items: [a_hash_including(uuid: @vocab_term_1.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end
        end

        context "multiple matches" do
          it "returns VocabTerms matching the content" do
            send api_method, url_proc.call(q: 'content:"lOrEm IpSuM"'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @vocab_term_1.uuid),
                      a_hash_including(uuid: @vocab_term_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "returns VocabTerms matching the tags" do
            send api_method, url_proc.call(q: 'tag:TaG2'), @user_1_token
            expect(response).to have_http_status(:ok)

            expected_response = {
              total_count: 2,
              items: [a_hash_including(uuid: @vocab_term_1.uuid),
                      a_hash_including(uuid: @vocab_term_2.uuid)]
            }

            expect(response.body_as_hash).to match(expected_response)
          end

          it "sorts by multiple fields in different directions" do
            send api_method, url_proc.call(
              q: 'content:"lOrEm IpSuM"', order_by: 'number DESC, version ASC'
            ), @user_1_token
            expect(response).to have_http_status(:ok)

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
  end

  context "GET /api/vocab_terms/:id" do
    before(:all) do
      DatabaseCleaner.start

      @vocab_term.publication.publish.save!

      @vocab_term_2 = @vocab_term.new_version
      @vocab_term_2.save!
    end
    after(:all) { DatabaseCleaner.clean }

    it "returns the VocabTerm requested by group_uuid and version" do
      api_get api_vocab_term_url("#{@vocab_term.group_uuid}@#{@vocab_term.version}"), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
    end

    it "returns the VocabTerm requested by uuid" do
      api_get api_vocab_term_url(@vocab_term.uuid), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
    end

    it "returns the VocabTerm requested by uid" do
      api_get api_vocab_term_url(@vocab_term.uid), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
    end

    it "returns the latest published VocabTerm if only the group_uuid is specified" do
      api_get api_vocab_term_url(@vocab_term.group_uuid), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
    end

    it "returns the latest published VocabTerm if only the number is specified" do
      api_get api_vocab_term_url(@vocab_term.number), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term.uuid))
    end

    it "returns the latest draft VocabTerm if \"group_uuid@draft\" is requested" do
      api_get api_vocab_term_url("#{@vocab_term.group_uuid}@draft"), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term_2.uuid))
    end

    it "returns the latest draft VocabTerm if \"number@draft\" is requested" do
      api_get api_vocab_term_url("#{@vocab_term.number}@draft"), @user_1_token
      expect(response).to have_http_status(:ok)
      expect(response.body_as_hash).to match(a_hash_including(uuid: @vocab_term_2.uuid))
    end

    it "creates a new draft version if no draft and \"@draft\" is requested" do
      @vocab_term_2.destroy

      expect do
        api_get api_vocab_term_url("#{@vocab_term.number}@draft"), @user_1_token
      end.to change{ VocabTerm.count }.by(1)
      expect(response).to have_http_status(:ok)

      new_vocab_term = VocabTerm.order(:created_at).last
      expect(new_vocab_term.id).not_to eq @vocab_term.id
      expect(new_vocab_term.number).to eq @vocab_term.number
      expect(new_vocab_term.version).to eq @vocab_term.version + 1

      expect(new_vocab_term.attributes.except('id', 'created_at', 'updated_at'))
        .to eq(@vocab_term.attributes.except('id', 'created_at', 'updated_at'))
    end
  end

  context "POST /api/vocab_terms" do
    before(:all) do
      DatabaseCleaner.start

      VocabTerm.where(id: @vocab_term.id).destroy_all
      PublicationGroup.where(id: @vocab_term.publication.publication_group_id).delete_all
    end
    after(:all) { DatabaseCleaner.clean }

    before { Rails.cache.clear }

    it "creates the requested VocabTerm and assigns the user as author and CR holder" do
      expect do
        api_post api_vocab_terms_url, @user_1_token,
                 params: Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
                   @vocab_term
                 ).to_json(user_options: { user: @user_1 })
      end.to change { VocabTerm.count }.by(1)
      expect(response).to have_http_status(:created)

      new_vocab_term = VocabTerm.order(:created_at).last
      expect(new_vocab_term.nickname).to eq 'MyVocab'
      expect(new_vocab_term.name).to eq @vocab_term.name
      expect(new_vocab_term.definition).to eq @vocab_term.definition

      expect(new_vocab_term.authors.first.user).to eq @user_1
      expect(new_vocab_term.copyright_holders.first.user).to eq @user_1
    end

    it "assigns the author and copyright holder through delegations" do
      FactoryBot.create :delegation, delegator: @user_2,
                                     delegate: @user_1,
                                     can_assign_authorship: true,
                                     can_assign_copyright: false
      FactoryBot.create :delegation, delegator: @user_3,
                                     delegate: @user_1,
                                     can_assign_authorship: false,
                                     can_assign_copyright: true

      expect do
        api_post api_vocab_terms_url, @user_1_token,
                 params: Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
                   @vocab_term
                 ).to_json(user_options: { user: @user_1 })
      end.to change { VocabTerm.count }.by(1)
      expect(response).to have_http_status(:created)

      new_vocab_term = VocabTerm.order(:created_at).last

      authors = new_vocab_term.authors.map(&:user)
      expect(authors).to include(@user_1)
      expect(authors).to include(@user_2)
      expect(authors).not_to include(@user_3)

      copyright_holders = new_vocab_term.copyright_holders.map(&:user)
      expect(copyright_holders).to include(@user_1)
      expect(copyright_holders).not_to include(@user_2)
      expect(copyright_holders).to include(@user_3)
    end

    it "fails if the nickname has already been taken" do
      FactoryBot.create :publication_group, nickname: 'MyVocab'

      expect do
        api_post api_vocab_terms_url, @user_1_token,
                 params: Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter.new(
                   @vocab_term
                 ).to_json(user_options: { user: @user_1 })
      end.not_to change { VocabTerm.count }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body_as_hash[:errors].first[:code]).to eq 'nickname_has_already_been_taken'
    end
  end

  context "PATCH /api/vocab_terms/:id" do
    before { @old_attributes = @vocab_term.reload.attributes }

    it "updates the requested VocabTerm" do
      api_patch api_vocab_term_url(@vocab_term.uid), @user_1_token, params: {
        nickname: 'MyVocab', term: "Ipsum lorem"
      }.to_json
      expect(response).to have_http_status(:ok)
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
        api_patch api_vocab_term_url(@vocab_term.uid), @user_1_token, params: {
          nickname: 'MyVocab', term: "Ipsum lorem"
        }.to_json
      end.to raise_error(SecurityTransgression)

      @vocab_term.reload
      expect(@vocab_term.attributes.except('updated_at')).to(
        eq @old_attributes.except('updated_at')
      )
    end

    it "fails if the nickname has already been taken" do
      FactoryBot.create :publication_group, nickname: 'MyVocab2'

      api_patch api_vocab_term_url(@vocab_term.uid), @user_1_token, params: {
        nickname: 'MyVocab2', term: "Ipsum lorem"
      }.to_json

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

      api_patch api_vocab_term_url("#{@vocab_term.number}@draft"), @user_1_token, params: {
        nickname: 'MyVocab', term: "Ipsum lorem"
      }.to_json
      expect(response).to have_http_status(:ok)
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
        api_patch api_vocab_term_url("#{@vocab_term.number}@draft"), @user_1_token, params: {
          nickname: 'MyVocab', term: "Ipsum lorem"
        }.to_json
      end.to change{ VocabTerm.count }.by(1)
      expect(response).to have_http_status(:ok)
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

  context "DELETE /api/vocab_terms/:id" do
    it "deletes the requested draft VocabTerm" do
      expect do
        api_delete api_vocab_term_url(@vocab_term.uid), @user_1_token
      end.to change(VocabTerm, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(VocabTerm.where(id: @vocab_term.id)).not_to exist
    end
  end
end
