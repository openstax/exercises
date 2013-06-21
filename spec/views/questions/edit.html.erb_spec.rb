require 'spec_helper'

describe "questions/edit" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :exercise_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :order => 1,
      :credit => "9.99"
    ))
  end

  it "renders the edit question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", question_path(@question), "post" do
      assert_select "input#question_exercise_id[name=?]", "question[exercise_id]"
      assert_select "textarea#question_content[name=?]", "question[content]"
      assert_select "textarea#question_content_html[name=?]", "question[content_html]"
      assert_select "input#question_order[name=?]", "question[order]"
      assert_select "input#question_credit[name=?]", "question[credit]"
    end
  end
end
