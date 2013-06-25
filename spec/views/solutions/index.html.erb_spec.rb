require 'spec_helper'

describe "solutions/index" do
  before(:each) do
    assign(:solutions, [
      stub_model(Solution,
        :number => 1,
        :version => 2,
        :content => "MyText",
        :content_html => "MyText",
        :summary => "MyText",
        :question_id => 3,
        :creator_id => 4
      ),
      stub_model(Solution,
        :number => 1,
        :version => 2,
        :content => "MyText",
        :content_html => "MyText",
        :summary => "MyText",
        :question_id => 3,
        :creator_id => 4
      )
    ])
  end

  it "renders a list of solutions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
