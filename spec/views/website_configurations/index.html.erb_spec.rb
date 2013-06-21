require 'spec_helper'

describe "website_configurations/index" do
  before(:each) do
    assign(:website_configurations, [
      stub_model(WebsiteConfiguration,
        :name => "Name",
        :value => "Value",
        :value_type => 1
      ),
      stub_model(WebsiteConfiguration,
        :name => "Name",
        :value => "Value",
        :value_type => 1
      )
    ])
  end

  it "renders a list of website_configurations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
