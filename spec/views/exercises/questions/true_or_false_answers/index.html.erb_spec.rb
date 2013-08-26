require 'spec_helper'

describe "true_or_false_answers/index" do
  before(:each) do
    assign(:true_or_false_answers, [
      stub_model(TrueOrFalseAnswer,
        :question_id => 1,
        :content => "MyText",
        :content_html => "MyText",
        :is_true => false,
        :order => 2,
        :credit => "9.99"
      ),
      stub_model(TrueOrFalseAnswer,
        :question_id => 1,
        :content => "MyText",
        :content_html => "MyText",
        :is_true => false,
        :order => 2,
        :credit => "9.99"
      )
    ])
  end

  it "renders a list of true_or_false_answers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
