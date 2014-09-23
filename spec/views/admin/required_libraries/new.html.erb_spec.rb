require 'rails_helper'

RSpec.describe "required_libraries/new", :type => :view do
  before(:each) do
    assign(:required_library, RequiredLibrary.new(
      :library => nil
    ))
  end

  it "renders new required_library form" do
    render

    assert_select "form[action=?][method=?]", required_libraries_path, "post" do

      assert_select "input#required_library_library_id[name=?]", "required_library[library_id]"
    end
  end
end
