require 'spec_helper'

describe "user_group_users/show" do
  before(:each) do
    @user_group_user = assign(:user_group_user, stub_model(UserGroupUser,
      :user_group_id => 1,
      :user_id => 2,
      :is_group_manager => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/false/)
  end
end
