require 'rails_helper'

module Doorkeeper
  RSpec.describe "applications/index", :type => :view do
    before(:each) do
      assign(:applications, [
        Application.create!(),
        Application.create!()
      ])
    end

    it "renders a list of applications" do
      render
    end
  end
end
