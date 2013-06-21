require 'spec_helper'

describe "user_profiles/show" do
  before(:each) do
    @user_profile = assign(:user_profile, stub_model(UserProfile,
      :user_id => 1,
      :group_member_email => false,
      :collaborator_request_email => false,
      :announcement_email => false,
      :auto_author_subscribe => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
