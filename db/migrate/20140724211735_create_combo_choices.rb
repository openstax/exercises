class CreateComboChoices < ActiveRecord::Migration[4.2]
  def change
    create_table :combo_choices do |t|
      t.references :stem, null: false
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :feedback

      t.timestamps null: false
    end

    add_index :combo_choices, [:stem_id, :correctness]
  end
end
