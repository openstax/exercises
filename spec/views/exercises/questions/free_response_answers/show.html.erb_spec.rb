require 'spec_helper'

describe "free_response_answers/show" do
  before(:each) do
    @free_response_answer = assign(:free_response_answer, stub_model(FreeResponseAnswer,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :free_response => "MyText",
      :can_be_sketched => false,
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
    rendered.should match(/MyText/)
    rendered.should match(/false/)
    rendered.should match(/2/)
    rendered.should match(/9.99/)
  end
end
