require 'spec_helper'

describe "exercises/index" do
  before(:each) do
    assign(:exercises, [
      stub_model(Exercise,
        :number => 1,
        :version => 2,
        :content => "MyText",
        :content_html => "MyText",
        :license_id => 3,
        :locked_by => 4,
        :changes_solution => false,
        :only_embargo_solutions => false,
        :suggested_credit => "9.99"
      ),
      stub_model(Exercise,
        :number => 1,
        :version => 2,
        :content => "MyText",
        :content_html => "MyText",
        :license_id => 3,
        :locked_by => 4,
        :changes_solution => false,
        :only_embargo_solutions => false,
        :suggested_credit => "9.99"
      )
    ])
  end

  it "renders a list of exercises" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
