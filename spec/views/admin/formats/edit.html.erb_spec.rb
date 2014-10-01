require 'rails_helper'

module Admin
  RSpec.describe "licenses/edit", :type => :view do
    before(:each) do
      @license = assign(:license, License.create!())
    end

    it "renders the edit license form" do
      render

      assert_select "form[action=?][method=?]", license_path(@license), "post" do
      end
    end
  end
end
