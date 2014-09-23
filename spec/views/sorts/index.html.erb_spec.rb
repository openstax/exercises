require 'rails_helper'

RSpec.describe "sorts/index", :type => :view do
  before(:each) do
    assign(:sorts, [
      Sort.create!(
        :container => nil,
        :sortable => nil
      ),
      Sort.create!(
        :container => nil,
        :sortable => nil
      )
    ])
  end

  it "renders a list of sorts" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
