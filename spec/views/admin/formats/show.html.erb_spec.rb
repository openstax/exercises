require 'rails_helper'

module Admin
  RSpec.describe "licenses/show", :type => :view do
    before(:each) do
      @license = assign(:license, License.create!())
    end

    it "renders attributes in <p>" do
      render
    end
  end
end
