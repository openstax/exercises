require 'spec_helper'

describe "multiple_choice_answers/new" do
  before(:each) do
    assign(:multiple_choice_answer, stub_model(MultipleChoiceAnswer,
      :question_id => 1,
      :content => "MyString",
      :content_html => "MyString",
      :order => 1,
      :credit => "9.99"
    ).as_new_record)
  end

  it "renders new multiple_choice_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", multiple_choice_answers_path, "post" do
      assert_select "input#multiple_choice_answer_question_id[name=?]", "multiple_choice_answer[question_id]"
      assert_select "input#multiple_choice_answer_content[name=?]", "multiple_choice_answer[content]"
      assert_select "input#multiple_choice_answer_content_html[name=?]", "multiple_choice_answer[content_html]"
      assert_select "input#multiple_choice_answer_order[name=?]", "multiple_choice_answer[order]"
      assert_select "input#multiple_choice_answer_credit[name=?]", "multiple_choice_answer[credit]"
    end
  end
end
