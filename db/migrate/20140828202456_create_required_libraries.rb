class CreateRequiredLibraries < ActiveRecord::Migration
  def change
    create_table :required_libraries do |t|
      t.references :library, null: false

      t.timestamps null: false
    end

    add_index :required_libraries, :library_id, unique: true
  end
end
