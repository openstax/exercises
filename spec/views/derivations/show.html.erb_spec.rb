require 'spec_helper'

describe "derivations/show" do
  before(:each) do
    @derivation = assign(:derivation, stub_model(Derivation,
      :publishable_type => "Publishable Type",
      :source_publishable_id => 1,
      :derived_publishable_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Publishable Type/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
