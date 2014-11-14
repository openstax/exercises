class CreateLogics < ActiveRecord::Migration
  def change
    create_table :logics do |t|
      t.references :parent, polymorphic: true, null: false
      t.string :language, null: false
      t.text :code, null: false

      t.timestamps null: false
    end

    add_index :logics, [:parent_id, :parent_type, :language], unique: true
  end
end
