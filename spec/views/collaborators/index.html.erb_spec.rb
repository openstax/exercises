require 'spec_helper'

describe "collaborators/index" do
  before(:each) do
    assign(:collaborators, [
      stub_model(Collaborator,
        :user_id => 1,
        :exercise_id => 2,
        :order => 3,
        :is_author => false,
        :is_copyright_holder => false,
        :collaborator_requests_count => 4
      ),
      stub_model(Collaborator,
        :user_id => 1,
        :exercise_id => 2,
        :order => 3,
        :is_author => false,
        :is_copyright_holder => false,
        :collaborator_requests_count => 4
      )
    ])
  end

  it "renders a list of collaborators" do
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
