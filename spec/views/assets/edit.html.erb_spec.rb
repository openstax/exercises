require 'spec_helper'

describe "assets/edit" do
  before(:each) do
    @asset = assign(:asset, stub_model(Asset,
      :attachment_file_name => "MyString",
      :attachment_content_type => "MyString",
      :attachment_file_size => 1,
      :uploader_id => 1
    ))
  end

  it "renders the edit asset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", asset_path(@asset), "post" do
      assert_select "input#asset_attachment_file_name[name=?]", "asset[attachment_file_name]"
      assert_select "input#asset_attachment_content_type[name=?]", "asset[attachment_content_type]"
      assert_select "input#asset_attachment_file_size[name=?]", "asset[attachment_file_size]"
      assert_select "input#asset_uploader_id[name=?]", "asset[uploader_id]"
    end
  end
end
