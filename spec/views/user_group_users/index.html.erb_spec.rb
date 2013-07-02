require 'spec_helper'

describe "user_group_users/index" do
  before(:each) do
    assign(:user_group_users, [
      stub_model(UserGroupUser,
        :user_group_id => 1,
        :user_id => 2,
        :is_group_manager => false
      ),
      stub_model(UserGroupUser,
        :user_group_id => 1,
        :user_id => 2,
        :is_group_manager => false
      )
    ])
  end

  it "renders a list of user_group_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
