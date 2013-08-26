require 'spec_helper'

describe "derivations/edit" do
  before(:each) do
    @derivation = assign(:derivation, stub_model(Derivation,
      :publishable_type => "MyString",
      :source_publishable_id => 1,
      :derived_publishable_id => 1
    ))
  end

  it "renders the edit derivation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", derivation_path(@derivation), "post" do
      assert_select "input#derivation_publishable_type[name=?]", "derivation[publishable_type]"
      assert_select "input#derivation_source_publishable_id[name=?]", "derivation[source_publishable_id]"
      assert_select "input#derivation_derived_publishable_id[name=?]", "derivation[derived_publishable_id]"
    end
  end
end
