class CreateAnswerCombos < ActiveRecord::Migration
  def change
    create_table :answer_combos do |t|
      t.references :answer, null: false
      t.references :combo, null: false

      t.timestamps
    end

    add_index :answer_combos, [:answer_id, :combo_id], unique: true
    add_index :answer_combos, :combo_id
  end
end
