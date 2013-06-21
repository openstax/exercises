require 'spec_helper'

describe "list_exercises/edit" do
  before(:each) do
    @list_exercise = assign(:list_exercise, stub_model(ListExercise,
      :list_id => 1,
      :exercise_id => 1
    ))
  end

  it "renders the edit list_exercise form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", list_exercise_path(@list_exercise), "post" do
      assert_select "input#list_exercise_list_id[name=?]", "list_exercise[list_id]"
      assert_select "input#list_exercise_exercise_id[name=?]", "list_exercise[exercise_id]"
    end
  end
end
