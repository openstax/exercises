require 'spec_helper'

describe "free_response_answers/edit" do
  before(:each) do
    @free_response_answer = assign(:free_response_answer, stub_model(FreeResponseAnswer,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :free_response => "MyText",
      :can_be_sketched => false,
      :order => 1,
      :credit => "9.99"
    ))
  end

  it "renders the edit free_response_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", free_response_answer_path(@free_response_answer), "post" do
      assert_select "input#free_response_answer_question_id[name=?]", "free_response_answer[question_id]"
      assert_select "textarea#free_response_answer_content[name=?]", "free_response_answer[content]"
      assert_select "textarea#free_response_answer_content_html[name=?]", "free_response_answer[content_html]"
      assert_select "textarea#free_response_answer_free_response[name=?]", "free_response_answer[free_response]"
      assert_select "input#free_response_answer_can_be_sketched[name=?]", "free_response_answer[can_be_sketched]"
      assert_select "input#free_response_answer_order[name=?]", "free_response_answer[order]"
      assert_select "input#free_response_answer_credit[name=?]", "free_response_answer[credit]"
    end
  end
end
