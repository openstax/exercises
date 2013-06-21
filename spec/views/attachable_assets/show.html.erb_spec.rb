require 'spec_helper'

describe "attachable_assets/show" do
  before(:each) do
    @attachable_asset = assign(:attachable_asset, stub_model(AttachableAsset,
      :attachable_id => 1,
      :asset_id => 2,
      :local_name => "Local Name",
      :description => "MyText",
      :attachable_type => "Attachable Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Local Name/)
    rendered.should match(/MyText/)
    rendered.should match(/Attachable Type/)
  end
end
