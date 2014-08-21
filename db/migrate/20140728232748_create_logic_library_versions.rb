class CreateLogicLibraryVersions < ActiveRecord::Migration
  def change
    create_table :logic_library_versions do |t|
      t.references :logic, null: false
      t.references :library_version, null: false

      t.timestamps
    end

    add_index :logic_library_versions, [:logic_id, :library_version_id], unique: true,
              name: 'index_logic_library_versions_on_l_id_and_l_v_id'
    add_index :logic_library_versions, :library_version_id
  end
end
