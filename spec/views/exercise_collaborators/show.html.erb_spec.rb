require 'spec_helper'

describe "exercise_collaborators/show" do
  before(:each) do
    @exercise_collaborator = assign(:exercise_collaborator, stub_model(ExerciseCollaborator,
      :user_id => 1,
      :exercise_id => 2,
      :order => 3,
      :is_author => false,
      :is_copyright_holder => false,
      :exercise_collaborator_requests_count => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/4/)
  end
end
