require 'rails_helper'

module Doorkeeper
  RSpec.describe "applications/edit", :type => :view do
    before(:each) do
      @application = assign(:application, Application.create!())
    end

    it "renders the edit application form" do
      render

      assert_select "form[action=?][method=?]", application_path(@application), "post" do
      end
    end
  end
end
