class CreateComboChoices < ActiveRecord::Migration
  def change
    create_table :combo_choices do |t|
      t.sortable
      t.references :question, null: false
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :feedback

      t.timestamps
    end

    add_sortable_index :combo_choices, :question_id
    add_index :combo_choices, :correctness
  end
end
