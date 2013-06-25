require 'spec_helper'

describe "exercise_derivations/edit" do
  before(:each) do
    @exercise_derivation = assign(:exercise_derivation, stub_model(ExerciseDerivation,
      :derived_exercise_id => 1,
      :source_exercise_id => 1,
      :deriver_id => 1
    ))
  end

  it "renders the edit exercise_derivation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", exercise_derivation_path(@exercise_derivation), "post" do
      assert_select "input#exercise_derivation_derived_exercise_id[name=?]", "exercise_derivation[derived_exercise_id]"
      assert_select "input#exercise_derivation_source_exercise_id[name=?]", "exercise_derivation[source_exercise_id]"
      assert_select "input#exercise_derivation_deriver_id[name=?]", "exercise_derivation[deriver_id]"
    end
  end
end
