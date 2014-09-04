require 'rails_helper'

RSpec.describe "trusted_applications/show", :type => :view do
  before(:each) do
    @trusted_application = assign(:trusted_application, TrustedApplication.create!(
      :application => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
