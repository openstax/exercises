require 'spec_helper'

describe "attachable_assets/new" do
  before(:each) do
    assign(:attachable_asset, stub_model(AttachableAsset,
      :attachable_id => 1,
      :asset_id => 1,
      :local_name => "MyString",
      :description => "MyText",
      :attachable_type => "MyString"
    ).as_new_record)
  end

  it "renders new attachable_asset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", attachable_assets_path, "post" do
      assert_select "input#attachable_asset_attachable_id[name=?]", "attachable_asset[attachable_id]"
      assert_select "input#attachable_asset_asset_id[name=?]", "attachable_asset[asset_id]"
      assert_select "input#attachable_asset_local_name[name=?]", "attachable_asset[local_name]"
      assert_select "textarea#attachable_asset_description[name=?]", "attachable_asset[description]"
      assert_select "input#attachable_asset_attachable_type[name=?]", "attachable_asset[attachable_type]"
    end
  end
end
