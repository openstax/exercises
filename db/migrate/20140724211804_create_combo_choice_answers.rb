class CreateComboChoiceAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :combo_choice_answers do |t|
      t.references :combo_choice, null: false
      t.references :answer, null: false

      t.timestamps null: false
    end

    add_index :combo_choice_answers, [:answer_id, :combo_choice_id], unique: true
    add_index :combo_choice_answers, :combo_choice_id
  end
end
