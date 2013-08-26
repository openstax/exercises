require 'spec_helper'

describe "true_or_false_answers/show" do
  before(:each) do
    @true_or_false_answer = assign(:true_or_false_answer, stub_model(TrueOrFalseAnswer,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :is_true => false,
      :order => 2,
      :credit => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/false/)
    rendered.should match(/2/)
    rendered.should match(/9.99/)
  end
end
