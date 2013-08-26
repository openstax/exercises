require 'spec_helper'

describe "multiple_choice_answers/index" do
  before(:each) do
    assign(:multiple_choice_answers, [
      stub_model(MultipleChoiceAnswer,
        :question_id => 1,
        :content => "Content",
        :content_html => "Content Html",
        :order => 2,
        :credit => "9.99"
      ),
      stub_model(MultipleChoiceAnswer,
        :question_id => 1,
        :content => "Content",
        :content_html => "Content Html",
        :order => 2,
        :credit => "9.99"
      )
    ])
  end

  it "renders a list of multiple_choice_answers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    assert_select "tr>td", :text => "Content Html".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
