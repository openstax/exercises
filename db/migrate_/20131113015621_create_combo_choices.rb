class CreateComboChoices < ActiveRecord::Migration
  def change
    create_table :combo_choices do |t|
      t.float :credit
      t.integer :multiple_choice_question_id

      t.timestamps
    end

    add_index :combo_choices, :multiple_choice_question_id
  end
end
