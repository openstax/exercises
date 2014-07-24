class CreateLibraryVersions < ActiveRecord::Migration
  def change
    create_table :library_versions do |t|
      t.integer :library_id
      t.text :code
      t.integer :version
      t.boolean :deprecated

      t.timestamps
    end

    add_index :library_versions, :library_id
    add_index :library_versions, [:library_id, :version], unique: true
    add_index :library_versions, [:library_id, :deprecated]
  end
end
