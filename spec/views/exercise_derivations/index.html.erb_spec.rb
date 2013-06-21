require 'spec_helper'

describe "exercise_derivations/index" do
  before(:each) do
    assign(:exercise_derivations, [
      stub_model(ExerciseDerivation,
        :derived => "",
        :source_exercise_id => 1,
        :deriver_id => 2
      ),
      stub_model(ExerciseDerivation,
        :derived => "",
        :source_exercise_id => 1,
        :deriver_id => 2
      )
    ])
  end

  it "renders a list of exercise_derivations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
