require 'spec_helper'

describe "announcements/edit" do
  before(:each) do
    @announcement = assign(:announcement, stub_model(Announcement,
      :creator_id => 1,
      :subject => "MyString",
      :body => "MyText",
      :force => false
    ))
  end

  it "renders the edit announcement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", announcement_path(@announcement), "post" do
      assert_select "input#announcement_creator_id[name=?]", "announcement[creator_id]"
      assert_select "input#announcement_subject[name=?]", "announcement[subject]"
      assert_select "textarea#announcement_body[name=?]", "announcement[body]"
      assert_select "input#announcement_force[name=?]", "announcement[force]"
    end
  end
end
