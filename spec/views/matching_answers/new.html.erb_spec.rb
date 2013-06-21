require 'spec_helper'

describe "matching_answers/new" do
  before(:each) do
    assign(:matching_answer, stub_model(MatchingAnswer,
      :question_id => 1,
      :content => "MyString",
      :content_html => "MyString",
      :match_number => 1,
      :right_column => false,
      :order => 1,
      :credit => "9.99"
    ).as_new_record)
  end

  it "renders new matching_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", matching_answers_path, "post" do
      assert_select "input#matching_answer_question_id[name=?]", "matching_answer[question_id]"
      assert_select "input#matching_answer_content[name=?]", "matching_answer[content]"
      assert_select "input#matching_answer_content_html[name=?]", "matching_answer[content_html]"
      assert_select "input#matching_answer_match_number[name=?]", "matching_answer[match_number]"
      assert_select "input#matching_answer_right_column[name=?]", "matching_answer[right_column]"
      assert_select "input#matching_answer_order[name=?]", "matching_answer[order]"
      assert_select "input#matching_answer_credit[name=?]", "matching_answer[credit]"
    end
  end
end
