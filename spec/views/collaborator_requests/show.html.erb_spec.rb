require 'spec_helper'

describe "exercise_collaborator_requests/show" do
  before(:each) do
    @exercise_collaborator_request = assign(:exercise_collaborator_request, stub_model(ExerciseCollaboratorRequest,
      :exercise_collaborator_id => 1,
      :requester_id => 2,
      :toggle_is_author => false,
      :toggle_is_copyright_holder => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
