class CreateQuestionDependencyPairs < ActiveRecord::Migration
  def change
    create_table :question_dependency_pairs do |t|
      t.integer :independent_question_id
      t.integer :dependent_question_id
      t.integer :kind

      t.timestamps
    end
  end
end
