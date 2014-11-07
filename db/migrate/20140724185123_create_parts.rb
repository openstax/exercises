class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.references :exercise, null: false
      t.text :stimulus

      t.timestamps null: false
    end

    add_index :parts, :exercise_id
  end
end
