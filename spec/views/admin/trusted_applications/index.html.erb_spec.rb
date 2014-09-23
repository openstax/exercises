require 'rails_helper'

RSpec.describe "trusted_applications/index", :type => :view do
  before(:each) do
    assign(:trusted_applications, [
      TrustedApplication.create!(
        :application => nil
      ),
      TrustedApplication.create!(
        :application => nil
      )
    ])
  end

  it "renders a list of trusted_applications" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
