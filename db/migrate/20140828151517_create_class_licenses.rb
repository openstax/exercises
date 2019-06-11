class CreateClassLicenses < ActiveRecord::Migration[4.2]
  def change
    create_table :class_licenses do |t|
      t.sortable
      t.references :license, null: false
      t.string :class_name, null: false

      t.timestamps null: false
    end

    add_sortable_index :class_licenses, scope: :class_name
    add_index :class_licenses, [:license_id, :class_name], unique: true
  end
end
