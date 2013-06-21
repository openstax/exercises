require 'spec_helper'

describe "question_dependency_pairs/edit" do
  before(:each) do
    @question_dependency_pair = assign(:question_dependency_pair, stub_model(QuestionDependencyPair,
      :independent_question_id => 1,
      :dependent_question_id => 1,
      :kind => 1
    ))
  end

  it "renders the edit question_dependency_pair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", question_dependency_pair_path(@question_dependency_pair), "post" do
      assert_select "input#question_dependency_pair_independent_question_id[name=?]", "question_dependency_pair[independent_question_id]"
      assert_select "input#question_dependency_pair_dependent_question_id[name=?]", "question_dependency_pair[dependent_question_id]"
      assert_select "input#question_dependency_pair_kind[name=?]", "question_dependency_pair[kind]"
    end
  end
end
