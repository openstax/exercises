require 'spec_helper'

describe "exercises/show" do
  before(:each) do
    @exercise = assign(:exercise, stub_model(Exercise,
      :number => 1,
      :version => 2,
      :content => "MyText",
      :content_html => "MyText",
      :license_id => 3,
      :locked_by => 4,
      :changes_solution => false,
      :only_embargo_solutions => false,
      :suggested_credit => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/9.99/)
  end
end
