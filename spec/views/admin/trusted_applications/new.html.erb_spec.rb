require 'rails_helper'

RSpec.describe "trusted_applications/new", :type => :view do
  before(:each) do
    assign(:trusted_application, TrustedApplication.new(
      :application => nil
    ))
  end

  it "renders new trusted_application form" do
    render

    assert_select "form[action=?][method=?]", trusted_applications_path, "post" do

      assert_select "input#trusted_application_application_id[name=?]", "trusted_application[application_id]"
    end
  end
end
