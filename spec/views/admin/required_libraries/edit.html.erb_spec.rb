require 'rails_helper'

RSpec.describe "required_libraries/edit", :type => :view do
  before(:each) do
    @required_library = assign(:required_library, RequiredLibrary.create!(
      :library => nil
    ))
  end

  it "renders the edit required_library form" do
    render

    assert_select "form[action=?][method=?]", required_library_path(@required_library), "post" do

      assert_select "input#required_library_library_id[name=?]", "required_library[library_id]"
    end
  end
end
