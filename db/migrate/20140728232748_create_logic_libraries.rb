class CreateLogicLibraries < ActiveRecord::Migration
  def change
    create_table :logic_libraries do |t|
      t.references :logic, null: false
      t.references :library, null: false

      t.timestamps null: false
    end

    add_index :logic_libraries, [:logic_id, :library_id], unique: true
    add_index :logic_libraries, :library_id
  end
end
