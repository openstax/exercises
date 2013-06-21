require 'spec_helper'

describe "question_dependency_pairs/new" do
  before(:each) do
    assign(:question_dependency_pair, stub_model(QuestionDependencyPair,
      :independent_question_id => 1,
      :dependent_question_id => 1,
      :kind => 1
    ).as_new_record)
  end

  it "renders new question_dependency_pair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", question_dependency_pairs_path, "post" do
      assert_select "input#question_dependency_pair_independent_question_id[name=?]", "question_dependency_pair[independent_question_id]"
      assert_select "input#question_dependency_pair_dependent_question_id[name=?]", "question_dependency_pair[dependent_question_id]"
      assert_select "input#question_dependency_pair_kind[name=?]", "question_dependency_pair[kind]"
    end
  end
end
