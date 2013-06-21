require 'spec_helper'

describe "free_responses/index" do
  before(:each) do
    assign(:free_responses, [
      stub_model(FreeResponse,
        :question_id => 1,
        :content => "MyText",
        :content_html => "MyText",
        :free_response => "MyText",
        :order => 2,
        :credit => "9.99"
      ),
      stub_model(FreeResponse,
        :question_id => 1,
        :content => "MyText",
        :content_html => "MyText",
        :free_response => "MyText",
        :order => 2,
        :credit => "9.99"
      )
    ])
  end

  it "renders a list of free_responses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
