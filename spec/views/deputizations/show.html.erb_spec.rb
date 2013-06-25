require 'spec_helper'

describe "deputizations/show" do
  before(:each) do
    @deputization = assign(:deputization, stub_model(Deputization,
      :deputizer_id => 1,
      :deputy_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
