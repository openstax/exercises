require 'rails_helper'

module Doorkeeper
  RSpec.describe "applications/show", :type => :view do
    before(:each) do
      @application = assign(:application, Application.create!())
    end

    it "renders attributes in <p>" do
      render
    end
  end
end
