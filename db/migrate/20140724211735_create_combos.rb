class CreateCombos < ActiveRecord::Migration
  def change
    create_table :combos do |t|
      t.sortable
      t.references :question, null: false
      t.decimal :correctness, null: false, precision: 5, scale: 2, default: 0

      t.timestamps
    end

    add_sortable_index :combos, :question_id
  end
end
