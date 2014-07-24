class CreateCombos < ActiveRecord::Migration
  def change
    create_table :combos do |t|
      t.sortable
      t.references :question, null: false

      t.timestamps
    end

    add_sortable_index :combos, :question_id
  end
end
