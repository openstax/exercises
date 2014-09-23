require 'rails_helper'

module Doorkeeper
  RSpec.describe "applications/new", :type => :view do
    before(:each) do
      assign(:application, Application.new())
    end

    it "renders new application form" do
      render

      assert_select "form[action=?][method=?]", applications_path, "post" do
      end
    end
  end
end
