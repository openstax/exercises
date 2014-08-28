require 'rails_helper'

RSpec.describe "class_licenses/new", :type => :view do
  before(:each) do
    assign(:class_license, ClassLicense.new(
      :license => nil,
      :class_name => "MyString"
    ))
  end

  it "renders new class_license form" do
    render

    assert_select "form[action=?][method=?]", class_licenses_path, "post" do

      assert_select "input#class_license_license_id[name=?]", "class_license[license_id]"

      assert_select "input#class_license_class_name[name=?]", "class_license[class_name]"
    end
  end
end
