class CreateComboChoices < ActiveRecord::Migration
  def change
    create_table :combo_choices do |t|
      t.references :item, null: false
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :feedback

      t.timestamps
    end

    add_index :combo_choices, [:item_id, :correctness]
  end
end
