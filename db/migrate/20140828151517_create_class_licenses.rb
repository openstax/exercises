class CreateClassLicenses < ActiveRecord::Migration
  def change
    create_table :class_licenses do |t|
      t.references :license, null: false
      t.string :class_name, null: false

      t.timestamps null: false
    end

    add_index :class_licenses, [:license_id, :class_name], unique: true
    add_index :class_licenses, :class_name
  end
end
