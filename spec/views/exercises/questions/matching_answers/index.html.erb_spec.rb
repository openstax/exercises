require 'spec_helper'

describe "matching_answers/index" do
  before(:each) do
    assign(:matching_answers, [
      stub_model(MatchingAnswer,
        :question_id => 1,
        :content => "Content",
        :content_html => "Content Html",
        :match_number => 2,
        :right_column => false,
        :order => 3,
        :credit => "9.99"
      ),
      stub_model(MatchingAnswer,
        :question_id => 1,
        :content => "Content",
        :content_html => "Content Html",
        :match_number => 2,
        :right_column => false,
        :order => 3,
        :credit => "9.99"
      )
    ])
  end

  it "renders a list of matching_answers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    assert_select "tr>td", :text => "Content Html".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
