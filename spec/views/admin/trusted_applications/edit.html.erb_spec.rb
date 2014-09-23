require 'rails_helper'

RSpec.describe "trusted_applications/edit", :type => :view do
  before(:each) do
    @trusted_application = assign(:trusted_application, TrustedApplication.create!(
      :application => nil
    ))
  end

  it "renders the edit trusted_application form" do
    render

    assert_select "form[action=?][method=?]", trusted_application_path(@trusted_application), "post" do

      assert_select "input#trusted_application_application_id[name=?]", "trusted_application[application_id]"
    end
  end
end
