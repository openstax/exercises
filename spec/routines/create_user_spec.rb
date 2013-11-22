require 'spec_helper'

describe CreateUser do

  let (:connect_user) do
    mock_model OpenStax::Connect::User, name: 'Bobby Joe'
  end

  it "works" do
    result = nil
    expect {
      result = CreateUser.call(connect_user)
    }.to change{User.count}.by 1

    user = result.outputs[:user]

    expect(user).not_to be nil
    expect(user.default_list).not_to be nil
    expect(user.deputy_user_group).not_to be nil
  end

end