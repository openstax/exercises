require 'spec_helper'

describe "website_configurations/new" do
  before(:each) do
    assign(:website_configuration, stub_model(WebsiteConfiguration,
      :name => "MyString",
      :value => "MyString",
      :value_type => 1
    ).as_new_record)
  end

  it "renders new website_configuration form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", website_configurations_path, "post" do
      assert_select "input#website_configuration_name[name=?]", "website_configuration[name]"
      assert_select "input#website_configuration_value[name=?]", "website_configuration[value]"
      assert_select "input#website_configuration_value_type[name=?]", "website_configuration[value_type]"
    end
  end
end
