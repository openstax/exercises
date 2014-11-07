class CreateComboChoices < ActiveRecord::Migration
  def change
    create_table :combo_choices do |t|
      t.references :question, null: false
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :feedback

      t.timestamps null: false
    end

    add_index :combo_choices, [:question_id, :correctness]
  end
end
