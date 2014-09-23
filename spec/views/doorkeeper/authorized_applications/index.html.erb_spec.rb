require 'rails_helper'

module Doorkeeper
  RSpec.describe "authorized_applications/index", :type => :view do
    before(:each) do
      assign(:authorized_applications, [
        AuthorizedApplication.create!(),
        AuthorizedApplication.create!()
      ])
    end

    it "renders a list of authorized_applications" do
      render
    end
  end
end
