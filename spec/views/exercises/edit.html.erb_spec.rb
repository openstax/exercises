require 'spec_helper'

describe "exercises/edit" do
  before(:each) do
    @exercise = assign(:exercise, stub_model(Exercise,
      :number => 1,
      :version => 1,
      :content => "MyText",
      :content_html => "MyText",
      :license_id => 1,
      :locked_by => 1,
      :changes_solution => false,
      :only_embargo_solutions => false,
      :suggested_credit => "9.99"
    ))
  end

  it "renders the edit exercise form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", exercise_path(@exercise), "post" do
      assert_select "input#exercise_number[name=?]", "exercise[number]"
      assert_select "input#exercise_version[name=?]", "exercise[version]"
      assert_select "textarea#exercise_content[name=?]", "exercise[content]"
      assert_select "textarea#exercise_content_html[name=?]", "exercise[content_html]"
      assert_select "input#exercise_license_id[name=?]", "exercise[license_id]"
      assert_select "input#exercise_locked_by[name=?]", "exercise[locked_by]"
      assert_select "input#exercise_changes_solution[name=?]", "exercise[changes_solution]"
      assert_select "input#exercise_only_embargo_solutions[name=?]", "exercise[only_embargo_solutions]"
      assert_select "input#exercise_suggested_credit[name=?]", "exercise[suggested_credit]"
    end
  end
end
