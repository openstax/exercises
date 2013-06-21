require 'spec_helper'

describe "licenses/new" do
  before(:each) do
    assign(:license, stub_model(License,
      :short_name => "MyString",
      :long_name => "MyString",
      :url => "MyString",
      :partial_name => "MyString",
      :is_default => false
    ).as_new_record)
  end

  it "renders new license form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", licenses_path, "post" do
      assert_select "input#license_short_name[name=?]", "license[short_name]"
      assert_select "input#license_long_name[name=?]", "license[long_name]"
      assert_select "input#license_url[name=?]", "license[url]"
      assert_select "input#license_partial_name[name=?]", "license[partial_name]"
      assert_select "input#license_is_default[name=?]", "license[is_default]"
    end
  end
end
