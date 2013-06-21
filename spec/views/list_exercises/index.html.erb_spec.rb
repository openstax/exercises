require 'spec_helper'

describe "list_exercises/index" do
  before(:each) do
    assign(:list_exercises, [
      stub_model(ListExercise,
        :list_id => 1,
        :exercise_id => 2
      ),
      stub_model(ListExercise,
        :list_id => 1,
        :exercise_id => 2
      )
    ])
  end

  it "renders a list of list_exercises" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
