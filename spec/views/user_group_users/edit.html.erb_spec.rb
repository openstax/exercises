require 'spec_helper'

describe "user_group_users/edit" do
  before(:each) do
    @user_group_user = assign(:user_group_user, stub_model(UserGroupUser,
      :user_group_id => 1,
      :user_id => 1,
      :is_group_manager => false
    ))
  end

  it "renders the edit user_group_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_group_user_path(@user_group_user), "post" do
      assert_select "input#user_group_user_user_group_id[name=?]", "user_group_user[user_group_id]"
      assert_select "input#user_group_user_user_id[name=?]", "user_group_user[user_id]"
      assert_select "input#user_group_user_is_group_manager[name=?]", "user_group_user[is_group_manager]"
    end
  end
end
