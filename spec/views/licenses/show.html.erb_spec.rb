require 'spec_helper'

describe "licenses/show" do
  before(:each) do
    @license = assign(:license, stub_model(License,
      :short_name => "Short Name",
      :long_name => "Long Name",
      :url => "Url",
      :partial_name => "Partial Name",
      :is_default => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Short Name/)
    rendered.should match(/Long Name/)
    rendered.should match(/Url/)
    rendered.should match(/Partial Name/)
    rendered.should match(/false/)
  end
end
