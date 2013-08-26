require 'spec_helper'

describe "true_or_false_answers/edit" do
  before(:each) do
    @true_or_false_answer = assign(:true_or_false_answer, stub_model(TrueOrFalseAnswer,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :is_true => false,
      :order => 1,
      :credit => "9.99"
    ))
  end

  it "renders the edit true_or_false_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", true_or_false_answer_path(@true_or_false_answer), "post" do
      assert_select "input#true_or_false_answer_question_id[name=?]", "true_or_false_answer[question_id]"
      assert_select "textarea#true_or_false_answer_content[name=?]", "true_or_false_answer[content]"
      assert_select "textarea#true_or_false_answer_content_html[name=?]", "true_or_false_answer[content_html]"
      assert_select "input#true_or_false_answer_is_true[name=?]", "true_or_false_answer[is_true]"
      assert_select "input#true_or_false_answer_order[name=?]", "true_or_false_answer[order]"
      assert_select "input#true_or_false_answer_credit[name=?]", "true_or_false_answer[credit]"
    end
  end
end
