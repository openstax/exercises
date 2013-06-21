require 'spec_helper'

describe "exercise_derivations/new" do
  before(:each) do
    assign(:exercise_derivation, stub_model(ExerciseDerivation,
      :derived => "",
      :source_exercise_id => 1,
      :deriver_id => 1
    ).as_new_record)
  end

  it "renders new exercise_derivation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", exercise_derivations_path, "post" do
      assert_select "input#exercise_derivation_derived[name=?]", "exercise_derivation[derived]"
      assert_select "input#exercise_derivation_source_exercise_id[name=?]", "exercise_derivation[source_exercise_id]"
      assert_select "input#exercise_derivation_deriver_id[name=?]", "exercise_derivation[deriver_id]"
    end
  end
end
