require 'spec_helper'

describe "derivations/index" do
  before(:each) do
    assign(:derivations, [
      stub_model(Derivation,
        :publishable_type => "Publishable Type",
        :source_publishable_id => 1,
        :derived_publishable_id => 2
      ),
      stub_model(Derivation,
        :publishable_type => "Publishable Type",
        :source_publishable_id => 1,
        :derived_publishable_id => 2
      )
    ])
  end

  it "renders a list of derivations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Publishable Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
