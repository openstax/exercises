require 'rails_helper'

RSpec.describe "languages/new", :type => :view do
  before(:each) do
    assign(:language, Language.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new language form" do
    render

    assert_select "form[action=?][method=?]", languages_path, "post" do

      assert_select "input#language_name[name=?]", "language[name]"

      assert_select "textarea#language_description[name=?]", "language[description]"
    end
  end
end
