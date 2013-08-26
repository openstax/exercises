require 'spec_helper'

describe "derivations/new" do
  before(:each) do
    assign(:derivation, stub_model(Derivation,
      :publishable_type => "MyString",
      :source_publishable_id => 1,
      :derived_publishable_id => 1
    ).as_new_record)
  end

  it "renders new derivation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", derivations_path, "post" do
      assert_select "input#derivation_publishable_type[name=?]", "derivation[publishable_type]"
      assert_select "input#derivation_source_publishable_id[name=?]", "derivation[source_publishable_id]"
      assert_select "input#derivation_derived_publishable_id[name=?]", "derivation[derived_publishable_id]"
    end
  end
end
