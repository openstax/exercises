require 'spec_helper'

describe "matching_answers/show" do
  before(:each) do
    @matching_answer = assign(:matching_answer, stub_model(MatchingAnswer,
      :question_id => 1,
      :content => "Content",
      :content_html => "Content Html",
      :match_number => 2,
      :right_column => false,
      :order => 3,
      :credit => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Content/)
    rendered.should match(/Content Html/)
    rendered.should match(/2/)
    rendered.should match(/false/)
    rendered.should match(/3/)
    rendered.should match(/9.99/)
  end
end
