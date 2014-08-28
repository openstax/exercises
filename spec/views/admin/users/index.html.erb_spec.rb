require 'rails_helper'

module Admin
  RSpec.describe "users/index", :type => :view do
    before(:each) do
      assign(:users, [
        User.create!(),
        User.create!()
      ])
    end

    it "renders a list of users" do
      render
    end
  end
end
