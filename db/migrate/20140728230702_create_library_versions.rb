class CreateLibraryVersions < ActiveRecord::Migration
  def change
    create_table :library_versions do |t|
      t.references :library, null: false
      t.integer :version, null: false
      t.datetime :deprecated_at
      t.text :code, null: false

      t.timestamps
    end

    add_index :library_versions, [:library_id, :version], unique: true
    add_index :library_versions, :deprecated_at
  end
end
