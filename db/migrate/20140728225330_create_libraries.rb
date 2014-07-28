class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.references :owner
      t.string :language, null: false
      t.string :name, null: false
      t.text :summary
      t.boolean :is_prerequisite, null: false, default: false

      t.timestamps
    end

    add_index :libraries, [:owner_id, :name], unique: true
    add_index :libraries, :is_prerequisite
    add_index :libraries, :language
  end
end
