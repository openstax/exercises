require 'spec_helper'

describe "announcements/index" do
  before(:each) do
    assign(:announcements, [
      stub_model(Announcement,
        :creator_id => 1,
        :subject => "Subject",
        :body => "MyText",
        :force => false
      ),
      stub_model(Announcement,
        :creator_id => 1,
        :subject => "Subject",
        :body => "MyText",
        :force => false
      )
    ])
  end

  it "renders a list of announcements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
