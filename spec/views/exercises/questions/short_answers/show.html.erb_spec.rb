require 'spec_helper'

describe "short_answers/show" do
  before(:each) do
    @short_answer = assign(:short_answer, stub_model(ShortAnswer,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :short_answer => "Short Answer",
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
    rendered.should match(/Short Answer/)
    rendered.should match(/2/)
    rendered.should match(/9.99/)
  end
end
