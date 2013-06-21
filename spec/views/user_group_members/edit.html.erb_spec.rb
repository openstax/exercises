require 'spec_helper'

describe "user_group_members/edit" do
  before(:each) do
    @user_group_member = assign(:user_group_member, stub_model(UserGroupMember,
      :user_group_id => 1,
      :user_id => 1,
      :is_group_manager => false
    ))
  end

  it "renders the edit user_group_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_group_member_path(@user_group_member), "post" do
      assert_select "input#user_group_member_user_group_id[name=?]", "user_group_member[user_group_id]"
      assert_select "input#user_group_member_user_id[name=?]", "user_group_member[user_id]"
      assert_select "input#user_group_member_is_group_manager[name=?]", "user_group_member[is_group_manager]"
    end
  end
end
