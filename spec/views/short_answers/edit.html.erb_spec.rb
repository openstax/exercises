require 'spec_helper'

describe "short_answers/edit" do
  before(:each) do
    @short_answer = assign(:short_answer, stub_model(ShortAnswer,
      :question_id => 1,
      :content => "MyText",
      :content_html => "MyText",
      :short_answer => "MyString",
      :order => 1,
      :credit => "9.99"
    ))
  end

  it "renders the edit short_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", short_answer_path(@short_answer), "post" do
      assert_select "input#short_answer_question_id[name=?]", "short_answer[question_id]"
      assert_select "textarea#short_answer_content[name=?]", "short_answer[content]"
      assert_select "textarea#short_answer_content_html[name=?]", "short_answer[content_html]"
      assert_select "input#short_answer_short_answer[name=?]", "short_answer[short_answer]"
      assert_select "input#short_answer_order[name=?]", "short_answer[order]"
      assert_select "input#short_answer_credit[name=?]", "short_answer[credit]"
    end
  end
end
