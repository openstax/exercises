require 'rails_helper'

RSpec.describe CreateUser do

  let (:accounts_user) do
    mock_model OpenStax::Accounts::User, name: 'Bobby Joe'
  end

  it "creates users" do
    result = nil
    expect {
      result = CreateUser.call(accounts_user)
    }.to change{User.count}.by 1

    user = result.outputs[:user]

    expect(user).not_to be nil
    expect(user.default_list).not_to be nil
    expect(user.deputy_user_group).not_to be nil
  end

end