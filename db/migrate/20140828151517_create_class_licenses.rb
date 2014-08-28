class CreateClassLicenses < ActiveRecord::Migration
  def change
    create_table :class_licenses do |t|
      t.references :license, index: true
      t.string :class_name

      t.timestamps
    end
  end
end
