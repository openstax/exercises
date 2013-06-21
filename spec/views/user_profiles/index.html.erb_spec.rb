require 'spec_helper'

describe "user_profiles/index" do
  before(:each) do
    assign(:user_profiles, [
      stub_model(UserProfile,
        :user_id => 1,
        :group_member_email => false,
        :collaborator_request_email => false,
        :announcement_email => false,
        :auto_author_subscribe => false
      ),
      stub_model(UserProfile,
        :user_id => 1,
        :group_member_email => false,
        :collaborator_request_email => false,
        :announcement_email => false,
        :auto_author_subscribe => false
      )
    ])
  end

  it "renders a list of user_profiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
