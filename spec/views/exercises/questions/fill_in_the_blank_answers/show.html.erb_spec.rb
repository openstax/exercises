require 'spec_helper'

describe "fill_in_the_blank_answers/show" do
  before(:each) do
    @fill_in_the_blank_answer = assign(:fill_in_the_blank_answer, stub_model(FillInTheBlankAnswer,
      :question_id => 1,
      :pre_content => "MyText",
      :pre_content_html => "MyText",
      :post_content => "MyText",
      :post_content_html => "MyText",
      :blank_answer => "Blank Answer",
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
    rendered.should match(/MyText/)
    rendered.should match(/Blank Answer/)
    rendered.should match(/2/)
    rendered.should match(/9.99/)
  end
end
