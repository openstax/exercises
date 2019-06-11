class CreateQuestionDependencies < ActiveRecord::Migration[4.2]
  def change
    create_table :question_dependencies do |t|
      t.references :parent_question, null: false
      t.references :dependent_question, null: false
      t.boolean :is_optional, null: false, default: false

      t.timestamps null: false
    end

    add_index :question_dependencies,
      [:dependent_question_id, :parent_question_id], unique: true,
      name: 'index_question_dependencies_on_dependent_q_id_and_parent_q_id'
    add_index :question_dependencies, :parent_question_id
  end
end
