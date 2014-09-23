require 'rails_helper'

module Dev
  RSpec.describe "dev/index", :type => :view do
    it "renders the dev console" do
      render
    end
  end
end
