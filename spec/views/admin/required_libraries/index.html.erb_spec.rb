require 'rails_helper'

RSpec.describe "required_libraries/index", :type => :view do
  before(:each) do
    assign(:required_libraries, [
      RequiredLibrary.create!(
        :library => nil
      ),
      RequiredLibrary.create!(
        :library => nil
      )
    ])
  end

  it "renders a list of required_libraries" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
