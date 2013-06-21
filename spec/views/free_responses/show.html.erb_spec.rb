require 'spec_helper'

describe "free_responses/show" do
  before(:each) do
    @free_response = assign(:free_response, stub_model(FreeResponse,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :free_response => "MyText",
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
    rendered.should match(/2/)
    rendered.should match(/9.99/)
  end
end
