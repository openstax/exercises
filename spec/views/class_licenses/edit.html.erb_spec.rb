require 'rails_helper'

RSpec.describe "class_licenses/edit", :type => :view do
  before(:each) do
    @class_license = assign(:class_license, ClassLicense.create!(
      :license => nil,
      :class_name => "MyString"
    ))
  end

  it "renders the edit class_license form" do
    render

    assert_select "form[action=?][method=?]", class_license_path(@class_license), "post" do

      assert_select "input#class_license_license_id[name=?]", "class_license[license_id]"

      assert_select "input#class_license_class_name[name=?]", "class_license[class_name]"
    end
  end
end
