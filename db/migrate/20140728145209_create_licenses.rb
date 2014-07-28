class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.sortable
      t.string :name, null: false
      t.string :short_name, null: false
      t.string :url, null: false
      t.string :publishing_contract_name, null: false
      t.boolean :allows_exercises, null: false, default: true
      t.boolean :allows_solutions, null: false, default: true

      t.timestamps
    end

    add_sortable_index :licenses
    add_index :licenses, :name, unique: true
    add_index :licenses, :short_name, unique: true
    add_index :licenses, :url, unique: true
  end
end
