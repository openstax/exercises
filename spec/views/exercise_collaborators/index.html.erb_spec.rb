require 'spec_helper'

describe "exercise_collaborators/index" do
  before(:each) do
    assign(:exercise_collaborators, [
      stub_model(ExerciseCollaborator,
        :user_id => 1,
        :exercise_id => 2,
        :order => 3,
        :is_author => false,
        :is_copyright_holder => false,
        :exercise_collaborator_requests_count => 4
      ),
      stub_model(ExerciseCollaborator,
        :user_id => 1,
        :exercise_id => 2,
        :order => 3,
        :is_author => false,
        :is_copyright_holder => false,
        :exercise_collaborator_requests_count => 4
      )
    ])
  end

  it "renders a list of exercise_collaborators" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
