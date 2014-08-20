require "spec_helper"

module Api::V1
  describe UsersController, type: :api, version: :v1 do

    let!(:untrusted_application)     { FactoryGirl.create :doorkeeper_application }
    let!(:trusted_application)     { FactoryGirl.create :doorkeeper_application, :trusted }
    let!(:user_1)          { FactoryGirl.create :openstax_accounts_user }
    let!(:user_2)          { FactoryGirl.create :openstax_accounts_user, first_name: 'Bob', last_name: 'Michaels' }
    let!(:admin_user)      { FactoryGirl.create :user, :admin }

    let!(:trusted_application_token) { FactoryGirl.create :doorkeeper_access_token,
                                                  application: trusted_application, 
                                                  resource_owner_id: nil }

    describe "index" do

      it "returns a single result well" do
        api_get :index, trusted_application_token, parameters: {q: 'first_name:bob last_name:Michaels'}
        expect(response.code).to eq('200')

        expected_response = {
          num_matching_users: 1,
          page: 0,
          per_page: 20,
          order_by: 'username ASC',
          users: [
            {
              id: user_2.id,
              username: user_2.username,
              first_name: user_2.first_name,
              last_name: user_2.last_name
            }
          ]
        }.to_json

        expect(response.body).to eq(expected_response)
      end

      let!(:billy_users) {
        (0..45).to_a.collect{|ii|
          FactoryGirl.create :openstax_accounts_user,
                             first_name: "Billy#{ii.to_s.rjust(2, '0')}",
                             last_name: "Fred_#{(45-ii).to_s.rjust(2,'0')}",
                             username: "billy_#{ii.to_s.rjust(2, '0')}"
        }
      }

      let!(:bob_brown) { FactoryGirl.create :openstax_accounts_user, first_name: "Bob", last_name: "Brown", username: "foo_bb" }
      let!(:bob_jones) { FactoryGirl.create :openstax_accounts_user, first_name: "Bob", last_name: "Jones", username: "foo_bj" }
      let!(:tim_jones) { FactoryGirl.create :openstax_accounts_user, first_name: "Tim", last_name: "Jones", username: "foo_tj" }

      it "should allow sort by multiple fields in different directions" do
        api_get :index, trusted_application_token, parameters: {q: 'username:foo', order_by: "first_name, last_name DESC"}

        outcome = JSON.parse(response.body)

        expect(outcome["users"].length).to eq 3
        expect(outcome["users"][0]["username"]).to eq "foo_bj"
        expect(outcome["users"][1]["username"]).to eq "foo_bb"
        expect(outcome["users"][2]["username"]).to eq "foo_tj"
        expect(outcome["order_by"]).to eq "first_name ASC, last_name DESC"
      end

      it "should return no results if the maximum number of results is exceeded" do
        api_get :index, trusted_application_token, parameters: {q: ''}
        expect(response.code).to eq('200')

        outcome = JSON.parse(response.body)

        expect(outcome["users"].length).to eq 0
        expect(outcome["num_matching_users"]).to eq 52
      end

    end

  end
end