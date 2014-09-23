require 'rails_helper'

module Doorkeeper
  RSpec.describe "authorizations/show", :type => :view do
    before(:each) do
      @authorization = assign(:authorization, Authorization.create!())
    end

    it "renders attributes in <p>" do
      render
    end
  end
end
