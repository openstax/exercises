require 'rails_helper'

RSpec.describe "languages/show", :type => :view do
  before(:each) do
    @language = assign(:language, Language.create!(
      :name => "Name",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
