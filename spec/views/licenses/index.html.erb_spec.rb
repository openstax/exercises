require 'spec_helper'

describe "licenses/index" do
  before(:each) do
    assign(:licenses, [
      stub_model(License,
        :short_name => "Short Name",
        :long_name => "Long Name",
        :url => "Url",
        :partial_name => "Partial Name",
        :is_default => false
      ),
      stub_model(License,
        :short_name => "Short Name",
        :long_name => "Long Name",
        :url => "Url",
        :partial_name => "Partial Name",
        :is_default => false
      )
    ])
  end

  it "renders a list of licenses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Long Name".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Partial Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
