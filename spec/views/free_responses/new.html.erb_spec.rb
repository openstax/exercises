require 'spec_helper'

describe "free_responses/new" do
  before(:each) do
    assign(:free_response, stub_model(FreeResponse,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :free_response => "MyText",
      :order => 1,
      :credit => "9.99"
    ).as_new_record)
  end

  it "renders new free_response form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", free_responses_path, "post" do
      assert_select "input#free_response_question_id[name=?]", "free_response[question_id]"
      assert_select "textarea#free_response_content[name=?]", "free_response[content]"
      assert_select "textarea#free_response_content_html[name=?]", "free_response[content_html]"
      assert_select "textarea#free_response_free_response[name=?]", "free_response[free_response]"
      assert_select "input#free_response_order[name=?]", "free_response[order]"
      assert_select "input#free_response_credit[name=?]", "free_response[credit]"
    end
  end
end
