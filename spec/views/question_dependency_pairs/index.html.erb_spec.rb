require 'spec_helper'

describe "question_dependency_pairs/index" do
  before(:each) do
    assign(:question_dependency_pairs, [
      stub_model(QuestionDependencyPair,
        :independent_question_id => 1,
        :dependent_question_id => 2,
        :kind => 3
      ),
      stub_model(QuestionDependencyPair,
        :independent_question_id => 1,
        :dependent_question_id => 2,
        :kind => 3
      )
    ])
  end

  it "renders a list of question_dependency_pairs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
