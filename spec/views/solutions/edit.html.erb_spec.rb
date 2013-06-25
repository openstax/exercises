require 'spec_helper'

describe "solutions/edit" do
  before(:each) do
    @solution = assign(:solution, stub_model(Solution,
      :number => 1,
      :version => 1,
      :content => "MyText",
      :content_html => "MyText",
      :summary => "MyText",
      :question_id => 1,
      :creator_id => 1
    ))
  end

  it "renders the edit solution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", solution_path(@solution), "post" do
      assert_select "input#solution_number[name=?]", "solution[number]"
      assert_select "input#solution_version[name=?]", "solution[version]"
      assert_select "textarea#solution_content[name=?]", "solution[content]"
      assert_select "textarea#solution_content_html[name=?]", "solution[content_html]"
      assert_select "textarea#solution_summary[name=?]", "solution[summary]"
      assert_select "input#solution_question_id[name=?]", "solution[question_id]"
      assert_select "input#solution_creator_id[name=?]", "solution[creator_id]"
    end
  end
end
