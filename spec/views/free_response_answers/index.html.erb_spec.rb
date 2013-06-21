require 'spec_helper'

describe "free_response_answers/index" do
  before(:each) do
    assign(:free_response_answers, [
      stub_model(FreeResponseAnswer,
        :question_id => 1,
        :content => "MyText",
        :content_html => "MyText",
        :free_response => "MyText",
        :can_be_sketched => false,
        :order => 2,
        :credit => "9.99"
      ),
      stub_model(FreeResponseAnswer,
        :question_id => 1,
        :content => "MyText",
        :content_html => "MyText",
        :free_response => "MyText",
        :can_be_sketched => false,
        :order => 2,
        :credit => "9.99"
      )
    ])
  end

  it "renders a list of free_response_answers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
