require 'spec_helper'

describe "exercise_collaborator_requests/index" do
  before(:each) do
    assign(:exercise_collaborator_requests, [
      stub_model(ExerciseCollaboratorRequest,
        :exercise_collaborator_id => 1,
        :requester_id => 2,
        :toggle_is_author => false,
        :toggle_is_copyright_holder => false
      ),
      stub_model(ExerciseCollaboratorRequest,
        :exercise_collaborator_id => 1,
        :requester_id => 2,
        :toggle_is_author => false,
        :toggle_is_copyright_holder => false
      )
    ])
  end

  it "renders a list of exercise_collaborator_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
