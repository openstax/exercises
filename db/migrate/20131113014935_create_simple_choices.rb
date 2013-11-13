class CreateSimpleChoices < ActiveRecord::Migration
  def change
    create_table :simple_choices do |t|
      t.integer :content_id
      t.integer :position
      t.float :credit
      t.integer :multiple_choice_question_id

      t.timestamps
    end

    add_index :simple_choices, :content_id
    add_index :simple_choices, :multiple_choice_question_id
    add_index :simple_choices, [:multiple_choice_question_id, :position], unique: true
  end
end
