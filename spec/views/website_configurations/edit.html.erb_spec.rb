require 'spec_helper'

describe "website_configurations/edit" do
  before(:each) do
    @website_configuration = assign(:website_configuration, stub_model(WebsiteConfiguration,
      :name => "MyString",
      :value => "MyString",
      :value_type => 1
    ))
  end

  it "renders the edit website_configuration form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", website_configuration_path(@website_configuration), "post" do
      assert_select "input#website_configuration_name[name=?]", "website_configuration[name]"
      assert_select "input#website_configuration_value[name=?]", "website_configuration[value]"
      assert_select "input#website_configuration_value_type[name=?]", "website_configuration[value_type]"
    end
  end
end
