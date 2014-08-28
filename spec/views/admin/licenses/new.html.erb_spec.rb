require 'rails_helper'

module Admin
  RSpec.describe "licenses/new", :type => :view do
    before(:each) do
      assign(:license, License.new())
    end

    it "renders new license form" do
      render

      assert_select "form[action=?][method=?]", licenses_path, "post" do
      end
    end
  end
end
