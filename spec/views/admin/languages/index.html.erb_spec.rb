require 'rails_helper'

RSpec.describe "languages/index", :type => :view do
  before(:each) do
    assign(:languages, [
      Language.create!(
        :name => "Name",
        :description => "MyText"
      ),
      Language.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of languages" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
