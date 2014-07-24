class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.sortable
      t.string :name, null: false, default: ''
      t.string :short_name, null: false, default: ''
      t.string :url, null: false, default: ''
      t.string :partial_filename, null: false, default: ''
      t.boolean :allow_exercises, null: false, default: true
      t.boolean :allow_solutions, null: false, default: true

      t.timestamps
    end

    add_sortable_index :licenses
    add_index :licenses, :name, unique: true
    add_index :licenses, :short_name, unique: true
    add_index :licenses, :url, unique: true
  end
end
