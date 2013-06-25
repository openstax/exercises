require 'spec_helper'

describe "deputizations/new" do
  before(:each) do
    assign(:deputization, stub_model(Deputization,
      :deputizer_id => 1,
      :deputy_id => 1
    ).as_new_record)
  end

  it "renders new deputization form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", deputizations_path, "post" do
      assert_select "input#deputization_deputizer_id[name=?]", "deputization[deputizer_id]"
      assert_select "input#deputization_deputy_id[name=?]", "deputization[deputy_id]"
    end
  end
end
