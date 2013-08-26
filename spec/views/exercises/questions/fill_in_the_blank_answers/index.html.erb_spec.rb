require 'spec_helper'

describe "fill_in_the_blank_answers/index" do
  before(:each) do
    assign(:fill_in_the_blank_answers, [
      stub_model(FillInTheBlankAnswer,
        :question_id => 1,
        :pre_content => "MyText",
        :pre_content_html => "MyText",
        :post_content => "MyText",
        :post_content_html => "MyText",
        :blank_answer => "Blank Answer",
        :order => 2,
        :credit => "9.99"
      ),
      stub_model(FillInTheBlankAnswer,
        :question_id => 1,
        :pre_content => "MyText",
        :pre_content_html => "MyText",
        :post_content => "MyText",
        :post_content_html => "MyText",
        :blank_answer => "Blank Answer",
        :order => 2,
        :credit => "9.99"
      )
    ])
  end

  it "renders a list of fill_in_the_blank_answers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Blank Answer".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
