require "rails_helper"

module Api::V1
  RSpec.describe UsersController, type: :controller, api: true, version: :v1 do

    let!(:application)      { FactoryBot.create :doorkeeper_application }

    let!(:user)             { FactoryBot.create :user, :agreed_to_terms, first_name: 'U',
                                                        last_name: 'ser', username: 'user' }
    let!(:admin)            { FactoryBot.create :user, :administrator,
                                                 :agreed_to_terms, first_name: 'Ad',
                                                 last_name: 'min', username: 'Admin'}

    let(:user_token)        { FactoryBot.create :doorkeeper_access_token,
                                                 application: application,
                                                 resource_owner_id: user.id }
    let(:admin_token)       { FactoryBot.create :doorkeeper_access_token,
                                                 application: application,
                                                 resource_owner_id: admin.id }
    let(:application_token) { FactoryBot.create :doorkeeper_access_token,
                                                 application: application,
                                                 resource_owner_id: nil }

    let(:response_hash)     { JSON.parse(response.body).deep_symbolize_keys }

    context "GET index" do

      before do
        100.times { FactoryBot.create(:user) }

        acc = OpenStax::Accounts::Account.arel_table
        User.joins(:account).where(acc[:first_name].matches('%doe%').or(
                                   acc[:last_name].matches('%doe%')).or(
                                   acc[:username].matches('%doe%'))).delete_all

        @john_doe = FactoryBot.create :user, first_name: "John",
                                              last_name: "Doe",
                                              username: "doejohn"
        @jane_doe = FactoryBot.create :user, first_name: "Jane",
                                              last_name: "Doe",
                                              username: "doejane"
        @john_doe.account.reload
        @jane_doe.account.reload
      end

      it "returns no results if the maximum number of results is exceeded" do
        api_get :index, admin_token, params: {q: ''}
        expect(response).to have_http_status(:success)

        expected_response = {
          total_count: OpenStax::Accounts::Account.count,
          items: []
        }

        expect(response_hash).to match(expected_response)
      end

      it "returns single results" do
        api_get :index, application_token, params: { q: 'first_name:jOhN last_name:dOe' }
        expect(response).to have_http_status(:success)

        expected_response = {
          total_count: 1,
          items: [
            {
              id: @john_doe.account.openstax_uid,
              username: @john_doe.username,
              first_name: @john_doe.first_name,
              last_name: @john_doe.last_name,
              full_name: @john_doe.full_name,
              title: @john_doe.title,
              faculty_status: @john_doe.faculty_status,
              self_reported_role: @john_doe.role,
              uuid: @john_doe.uuid,
              support_identifier: @john_doe.support_identifier,
              is_test: true
            }
          ]
        }

        expect(response_hash).to match(expected_response)
      end

      it "returns multiple results" do
        api_get :index, user_token, params: {q: 'last_name:DoE'}
        expect(response).to have_http_status(:success)

        expected_response = {
          total_count: 2,
          items: [
            {
              id: @jane_doe.account.openstax_uid,
              username: @jane_doe.username,
              first_name: @jane_doe.first_name,
              last_name: @jane_doe.last_name,
              full_name: @jane_doe.full_name,
              title: @jane_doe.title,
              faculty_status: @jane_doe.faculty_status,
              self_reported_role: @jane_doe.role,
              uuid: @jane_doe.uuid,
              support_identifier: @jane_doe.support_identifier,
              is_test: true
            },
            {
              id: @john_doe.account.openstax_uid,
              username: @john_doe.username,
              first_name: @john_doe.first_name,
              last_name: @john_doe.last_name,
              full_name: @john_doe.full_name,
              title: @john_doe.title,
              faculty_status: @john_doe.faculty_status,
              self_reported_role: @john_doe.role,
              uuid: @john_doe.uuid,
              support_identifier: @john_doe.support_identifier,
              is_test: true
            }
          ]
        }

        expect(response_hash).to match(expected_response)
      end

      it "sorts by multiple fields in different directions" do
        api_get :index, user_token, params: {q: 'username:doe',
                                                 order_by: "first_name DESC, last_name"}
        expect(response).to have_http_status(:success)

        expected_response = {
          total_count: 2,
          items: [
            {
              id: @john_doe.account.openstax_uid,
              username: @john_doe.username,
              first_name: @john_doe.first_name,
              last_name: @john_doe.last_name,
              full_name: @john_doe.full_name,
              title: @john_doe.title,
              faculty_status: @john_doe.faculty_status,
              self_reported_role: @john_doe.role,
              uuid: @john_doe.uuid,
              support_identifier: @john_doe.support_identifier,
              is_test: true
            },
            {
              id: @jane_doe.account.openstax_uid,
              username: @jane_doe.username,
              first_name: @jane_doe.first_name,
              last_name: @jane_doe.last_name,
              full_name: @jane_doe.full_name,
              title: @jane_doe.title,
              faculty_status: @jane_doe.faculty_status,
              self_reported_role: @jane_doe.role,
              uuid: @jane_doe.uuid,
              support_identifier: @jane_doe.support_identifier,
              is_test: true
            }
          ]
        }

        expect(response_hash).to match(expected_response)
      end

    end

    context "GET show" do

      it "returns the current User's info" do
        api_get :show, user_token
        expect(response).to have_http_status(:success)

        expected_response = {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
          full_name: user.full_name,
          title: user.title,
          faculty_status: user.faculty_status,
          self_reported_role: user.role,
          uuid: user.uuid,
          support_identifier: user.support_identifier
        }

        expect(response_hash).to match(expected_response)
      end

      it "ignores id parameters" do
        api_get :show, user_token, params: {id: admin.id, user_id: admin.id}
        expect(response).to have_http_status(:success)

        expected_response = {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
          full_name: user.full_name,
          title: user.title,
          faculty_status: user.faculty_status,
          self_reported_role: user.role,
          uuid: user.uuid,
          support_identifier: user.support_identifier
        }

        expect(response_hash).to match(expected_response)
      end

    end

    context "PATCH update" do

      it "updates the current User's profile" do
        api_patch :update, user_token, body: {
          first_name: "Jerry", last_name: "Mouse"
        }
        expect(response).to have_http_status(:success)
        user.reload
        expect(user.first_name).to eq 'Jerry'
        expect(user.last_name).to eq 'Mouse'
      end

      it "ignores id parameters" do
        api_patch :update, user_token, body: {
          first_name: "Jerry", last_name: "Mouse"
        }, params: {id: admin.id, user_id: admin.id}
        expect(response).to have_http_status(:success)
        user.reload
        admin.reload
        expect(user.first_name).to eq 'Jerry'
        expect(user.last_name).to eq 'Mouse'
        expect(admin.first_name).not_to eq 'Jerry'
        expect(admin.last_name).not_to eq 'Mouse'
      end

    end

    context "DELETE destroy" do

      it "deactivates the current User's account" do
        api_delete :destroy, user_token
        expect(response).to have_http_status(:success)
        user.reload
        expect(user.is_deleted?).to eq true
      end

      it "ignores id parameters" do
        api_delete :destroy, user_token, params: {id: admin.id, user_id: admin.id}
        expect(response).to have_http_status(:success)
        user.reload
        admin.reload
        expect(user.is_deleted?).to eq true
        expect(admin.is_deleted?).to eq false
      end

    end

  end
end
