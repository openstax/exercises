require 'spec_helper'

describe "list_exercises/show" do
  before(:each) do
    @list_exercise = assign(:list_exercise, stub_model(ListExercise,
      :list_id => 1,
      :exercise_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
