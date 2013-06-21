require 'spec_helper'

describe "website_configurations/show" do
  before(:each) do
    @website_configuration = assign(:website_configuration, stub_model(WebsiteConfiguration,
      :name => "Name",
      :value => "Value",
      :value_type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Value/)
    rendered.should match(/1/)
  end
end
