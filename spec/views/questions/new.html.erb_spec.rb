require 'spec_helper'

describe "questions/new" do
  before(:each) do
    assign(:question, stub_model(Question,
      :exercise_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :order => 1,
      :credit => "9.99"
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", questions_path, "post" do
      assert_select "input#question_exercise_id[name=?]", "question[exercise_id]"
      assert_select "textarea#question_content[name=?]", "question[content]"
      assert_select "textarea#question_content_html[name=?]", "question[content_html]"
      assert_select "input#question_order[name=?]", "question[order]"
      assert_select "input#question_credit[name=?]", "question[credit]"
    end
  end
end
