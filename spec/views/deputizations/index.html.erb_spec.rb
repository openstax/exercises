require 'spec_helper'

describe "deputizations/index" do
  before(:each) do
    assign(:deputizations, [
      stub_model(Deputization,
        :deputizer_id => 1,
        :deputy_id => 2
      ),
      stub_model(Deputization,
        :deputizer_id => 1,
        :deputy_id => 2
      )
    ])
  end

  it "renders a list of deputizations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
