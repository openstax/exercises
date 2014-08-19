class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.publishable
      t.logic
      t.references :question, null: false
      t.references :grading_algorithm
      t.text :human_instructions

      t.timestamps
    end

    add_publishable_indexes :rubrics, :question_id
    add_logic_index :rubrics
    add_index :rubrics, :grading_algorithm_id
  end
end
