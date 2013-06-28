class CreateQuestionDependencyPairs < ActiveRecord::Migration
  def change
    create_table :question_dependency_pairs do |t|
      t.integer :independent_question_id, :null => false
      t.integer :dependent_question_id, :null => false
      t.integer :kind, :null => false

      t.timestamps
    end

    add_index :question_dependency_pairs, [:independent_question_id, :dependent_question_id, :kind], :unique => true, :name => "index_qdp_on_iq_id_and_dq_id_and_kind"
    add_index :question_dependency_pairs, :dependent_question_id
  end
end
