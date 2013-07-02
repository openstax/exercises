require 'spec_helper'

describe "collaborators/new" do
  before(:each) do
    assign(:collaborator, stub_model(Collaborator,
      :user_id => 1,
      :exercise_id => 1,
      :order => 1,
      :is_author => false,
      :is_copyright_holder => false,
      :collaborator_requests_count => 1
    ).as_new_record)
  end

  it "renders new collaborator form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", collaborators_path, "post" do
      assert_select "input#collaborator_user_id[name=?]", "collaborator[user_id]"
      assert_select "input#collaborator_exercise_id[name=?]", "collaborator[exercise_id]"
      assert_select "input#collaborator_order[name=?]", "collaborator[order]"
      assert_select "input#collaborator_is_author[name=?]", "collaborator[is_author]"
      assert_select "input#collaborator_is_copyright_holder[name=?]", "collaborator[is_copyright_holder]"
      assert_select "input#collaborator_collaborator_requests_count[name=?]", "collaborator[collaborator_requests_count]"
    end
  end
end
