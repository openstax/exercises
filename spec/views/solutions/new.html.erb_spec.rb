require 'spec_helper'

describe "solutions/new" do
  before(:each) do
    assign(:solution, stub_model(Solution,
      :content => "MyText",
      :content_html => "MyText",
      :summary => "MyText",
      :question_id => 1
    ).as_new_record)
  end

  it "renders new solution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", solutions_path, "post" do
      assert_select "textarea#solution_content[name=?]", "solution[content]"
      assert_select "textarea#solution_content_html[name=?]", "solution[content_html]"
      assert_select "textarea#solution_summary[name=?]", "solution[summary]"
      assert_select "input#solution_question_id[name=?]", "solution[question_id]"
    end
  end
end
