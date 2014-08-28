require 'rails_helper'

RSpec.describe "class_licenses/show", :type => :view do
  before(:each) do
    @class_license = assign(:class_license, ClassLicense.create!(
      :license => nil,
      :class_name => "Class Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Class Name/)
  end
end
