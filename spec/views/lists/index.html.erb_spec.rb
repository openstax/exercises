require 'spec_helper'

describe "lists/index" do
  before(:each) do
    assign(:lists, [
      stub_model(List,
        :name => "Name",
        :reader_user_group_id => 1,
        :editor_user_group_id => 2,
        :publisher_user_group_id => 3,
        :manager_user_group_id => 4
      ),
      stub_model(List,
        :name => "Name",
        :reader_user_group_id => 1,
        :editor_user_group_id => 2,
        :publisher_user_group_id => 3,
        :manager_user_group_id => 4
      )
    ])
  end

  it "renders a list of lists" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
