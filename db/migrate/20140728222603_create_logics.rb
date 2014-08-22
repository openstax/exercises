class CreateLogics < ActiveRecord::Migration
  def change
    create_table :logics do |t|
      t.references :logicable, polymorphic: true, null: false
      t.text :code, null: false
      t.text :variables, null: false

      t.timestamps
    end

    add_index :logics, [:logicable_id, :logicable_type], unique: true
  end
end
