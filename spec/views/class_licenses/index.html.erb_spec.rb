require 'rails_helper'

RSpec.describe "class_licenses/index", :type => :view do
  before(:each) do
    assign(:class_licenses, [
      ClassLicense.create!(
        :license => nil,
        :class_name => "Class Name"
      ),
      ClassLicense.create!(
        :license => nil,
        :class_name => "Class Name"
      )
    ])
  end

  it "renders a list of class_licenses" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Class Name".to_s, :count => 2
  end
end
