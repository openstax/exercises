require 'spec_helper'

describe "attachable_assets/index" do
  before(:each) do
    assign(:attachable_assets, [
      stub_model(AttachableAsset,
        :attachable_id => 1,
        :asset_id => 2,
        :local_name => "Local Name",
        :description => "MyText",
        :attachable_type => "Attachable Type"
      ),
      stub_model(AttachableAsset,
        :attachable_id => 1,
        :asset_id => 2,
        :local_name => "Local Name",
        :description => "MyText",
        :attachable_type => "Attachable Type"
      )
    ])
  end

  it "renders a list of attachable_assets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Local Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Attachable Type".to_s, :count => 2
  end
end
