require 'spec_helper'

describe "lists/new" do
  before(:each) do
    assign(:list, stub_model(List,
      :name => "MyString",
      :reader_user_group_id => 1,
      :editor_user_group_id => 1,
      :publisher_user_group_id => 1,
      :manager_user_group_id => 1
    ).as_new_record)
  end

  it "renders new list form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", lists_path, "post" do
      assert_select "input#list_name[name=?]", "list[name]"
      assert_select "input#list_reader_user_group_id[name=?]", "list[reader_user_group_id]"
      assert_select "input#list_editor_user_group_id[name=?]", "list[editor_user_group_id]"
      assert_select "input#list_publisher_user_group_id[name=?]", "list[publisher_user_group_id]"
      assert_select "input#list_manager_user_group_id[name=?]", "list[manager_user_group_id]"
    end
  end
end
