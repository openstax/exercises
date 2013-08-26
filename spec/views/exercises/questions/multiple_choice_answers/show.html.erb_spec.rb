require 'spec_helper'

describe "multiple_choice_answers/show" do
  before(:each) do
    @multiple_choice_answer = assign(:multiple_choice_answer, stub_model(MultipleChoiceAnswer,
      :question_id => 1,
      :content => "Content",
      :content_html => "Content Html",
      :order => 2,
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
    rendered.should match(/9.99/)
  end
end
