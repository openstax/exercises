require 'spec_helper'

describe "solutions/show" do
  before(:each) do
    @solution = assign(:solution, stub_model(Solution,
      :number => 1,
      :version => 2,
      :content => "MyText",
      :content_html => "MyText",
      :summary => "MyText",
      :question_id => 3,
      :creator_id => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/3/)
    rendered.should match(/4/)
  end
end
