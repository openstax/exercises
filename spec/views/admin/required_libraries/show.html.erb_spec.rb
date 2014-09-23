require 'rails_helper'

RSpec.describe "required_libraries/show", :type => :view do
  before(:each) do
    @required_library = assign(:required_library, RequiredLibrary.create!(
      :library => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
