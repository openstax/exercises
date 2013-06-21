require 'spec_helper'

describe "exercise_collaborators/new" do
  before(:each) do
    assign(:exercise_collaborator, stub_model(ExerciseCollaborator,
      :user_id => 1,
      :exercise_id => 1,
      :order => 1,
      :is_author => false,
      :is_copyright_holder => false,
      :exercise_collaborator_requests_count => 1
    ).as_new_record)
  end

  it "renders new exercise_collaborator form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", exercise_collaborators_path, "post" do
      assert_select "input#exercise_collaborator_user_id[name=?]", "exercise_collaborator[user_id]"
      assert_select "input#exercise_collaborator_exercise_id[name=?]", "exercise_collaborator[exercise_id]"
      assert_select "input#exercise_collaborator_order[name=?]", "exercise_collaborator[order]"
      assert_select "input#exercise_collaborator_is_author[name=?]", "exercise_collaborator[is_author]"
      assert_select "input#exercise_collaborator_is_copyright_holder[name=?]", "exercise_collaborator[is_copyright_holder]"
      assert_select "input#exercise_collaborator_exercise_collaborator_requests_count[name=?]", "exercise_collaborator[exercise_collaborator_requests_count]"
    end
  end
end
