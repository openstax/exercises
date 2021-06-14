require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request, api: true, version: :v1 do
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

  context "GET /api/users" do
    before do
      30.times { FactoryBot.create(:user) }

      acc = OpenStax::Accounts::Account.arel_table
      acc_ids = OpenStax::Accounts::Account.where(
        acc[:first_name].matches('%doe%').or(
          acc[:last_name].matches('%doe%')
        ).or(
          acc[:username].matches('%doe%')
        )
      ).pluck(:id)
      User.where(account_id: acc_ids).delete_all
      OpenStax::Accounts::Account.where(id: acc_ids).delete_all

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
      api_get api_users_url(q: ''), admin_token
      expect(response).to have_http_status(:ok)

      expected_response = {
        total_count: OpenStax::Accounts::Account.count,
        items: []
      }

      expect(response_hash).to match(expected_response)
    end

    it "returns single results" do
      api_get api_users_url(q: 'first_name:jOhN last_name:dOe'), application_token
      expect(response).to have_http_status(:ok)

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
            is_test: true,
            school_type: 'unknown_school_type',
            school_location: 'unknown_school_location'
          }
        ]
      }

      expect(response_hash).to match(expected_response)
    end

    it "returns multiple results" do
      api_get api_users_url(q: 'last_name:DoE'), user_token
      expect(response).to have_http_status(:ok)

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
            is_test: true,
            school_type: 'unknown_school_type',
            school_location: 'unknown_school_location'
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
            is_test: true,
            school_type: 'unknown_school_type',
            school_location: 'unknown_school_location'
          }
        ]
      }

      expect(response_hash).to match(expected_response)
    end

    it "sorts by multiple fields in different directions" do
      api_get api_users_url(q: 'username:doe', order_by: 'first_name DESC, last_name'), user_token
      expect(response).to have_http_status(:ok)

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
            is_test: true,
            school_type: 'unknown_school_type',
            school_location: 'unknown_school_location'
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
            is_test: true,
            school_type: 'unknown_school_type',
            school_location: 'unknown_school_location'
          }
        ]
      }

      expect(response_hash).to match(expected_response)
    end
  end

  context "GET /api/user" do
    it "returns the current User's info" do
      api_get api_user_url, user_token
      expect(response).to have_http_status(:ok)

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
      api_get api_user_url(id: admin.id, user_id: admin.id), user_token, params: {
        id: admin.id,
        user_id: admin.id
      }.to_json
      expect(response).to have_http_status(:ok)

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

  context "PATCH /api/user" do
    it "updates the current User's profile" do
      api_patch api_user_url, user_token, params: {
        first_name: "Jerry", last_name: "Mouse"
      }.to_json
      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.first_name).to eq 'Jerry'
      expect(user.last_name).to eq 'Mouse'
    end

    it "ignores id parameters" do
      api_patch api_user_url(id: admin.id, user_id: admin.id), user_token, params: {
        id: admin.id,
        user_id: admin.id,
        first_name: "Jerry",
        last_name: "Mouse"
      }.to_json
      expect(response).to have_http_status(:ok)
      user.reload
      admin.reload
      expect(user.first_name).to eq 'Jerry'
      expect(user.last_name).to eq 'Mouse'
      expect(admin.first_name).not_to eq 'Jerry'
      expect(admin.last_name).not_to eq 'Mouse'
    end

  end

  context "DELETE /api/user" do
    it "deactivates the current User's account" do
      api_delete api_user_url, user_token
      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.is_deleted?).to eq true
    end

    it "ignores id parameters" do
      api_delete api_user_url(id: admin.id, user_id: admin.id), user_token, params: {
        id: admin.id,
        user_id: admin.id
      }.to_json
      expect(response).to have_http_status(:ok)
      user.reload
      admin.reload
      expect(user.is_deleted?).to eq true
      expect(admin.is_deleted?).to eq false
    end
  end
end
