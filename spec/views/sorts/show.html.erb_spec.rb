require 'rails_helper'

RSpec.describe "sorts/show", :type => :view do
  before(:each) do
    @sort = assign(:sort, Sort.create!(
      :container => nil,
      :sortable => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
