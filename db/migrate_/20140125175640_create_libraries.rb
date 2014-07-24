class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.integer :language
      t.string :name
      t.text :summary
      t.boolean :is_prerequisite
      t.integer :owner_id

      t.timestamps
    end

    add_index :libraries, :owner_id
    add_index :libraries, [:owner_id, :name], unique: true
    add_index :libraries, :is_prerequisite
    add_index :libraries, :language
  end
end
