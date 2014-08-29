class CreateLogics < ActiveRecord::Migration
  def change
    create_table :logics do |t|
      t.references :parent, polymorphic: true, null: false
      t.references :language, null: false
      t.text :code, null: false, default: ''

      t.timestamps
    end

    add_index :logics, [:parent_id, :parent_type, :language_id], unique: true
    add_index :logics, :language_id
  end
end
