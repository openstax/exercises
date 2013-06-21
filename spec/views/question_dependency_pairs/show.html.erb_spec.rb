require 'spec_helper'

describe "question_dependency_pairs/show" do
  before(:each) do
    @question_dependency_pair = assign(:question_dependency_pair, stub_model(QuestionDependencyPair,
      :independent_question_id => 1,
      :dependent_question_id => 2,
      :kind => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
