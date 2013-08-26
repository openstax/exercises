require 'spec_helper'

describe "fill_in_the_blank_answers/edit" do
  before(:each) do
    @fill_in_the_blank_answer = assign(:fill_in_the_blank_answer, stub_model(FillInTheBlankAnswer,
      :question_id => 1,
      :pre_content => "MyText",
      :pre_content_html => "MyText",
      :post_content => "MyText",
      :post_content_html => "MyText",
      :blank_answer => "MyString",
      :order => 1,
      :credit => "9.99"
    ))
  end

  it "renders the edit fill_in_the_blank_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", fill_in_the_blank_answer_path(@fill_in_the_blank_answer), "post" do
      assert_select "input#fill_in_the_blank_answer_question_id[name=?]", "fill_in_the_blank_answer[question_id]"
      assert_select "textarea#fill_in_the_blank_answer_pre_content[name=?]", "fill_in_the_blank_answer[pre_content]"
      assert_select "textarea#fill_in_the_blank_answer_pre_content_html[name=?]", "fill_in_the_blank_answer[pre_content_html]"
      assert_select "textarea#fill_in_the_blank_answer_post_content[name=?]", "fill_in_the_blank_answer[post_content]"
      assert_select "textarea#fill_in_the_blank_answer_post_content_html[name=?]", "fill_in_the_blank_answer[post_content_html]"
      assert_select "input#fill_in_the_blank_answer_blank_answer[name=?]", "fill_in_the_blank_answer[blank_answer]"
      assert_select "input#fill_in_the_blank_answer_order[name=?]", "fill_in_the_blank_answer[order]"
      assert_select "input#fill_in_the_blank_answer_credit[name=?]", "fill_in_the_blank_answer[credit]"
    end
  end
end
