require 'spec_helper'

describe "user_groups/new" do
  before(:each) do
    assign(:user_group, stub_model(UserGroup,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new user_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_groups_path, "post" do
      assert_select "input#user_group_name[name=?]", "user_group[name]"
    end
  end
end
