class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.sortable
      t.string :name, null: false
      t.string :short_name, null: false
      t.string :url, null: false
      t.text :publishing_contract, null: false
      t.text :copyright_notice, null: false
      t.text :can_combine_into, null: false, default: [].to_yaml
      t.boolean :allows_exercises, null: false, default: true
      t.boolean :allows_solutions, null: false, default: true
      t.boolean :is_public_domain, null: false, default: false

      t.timestamps
    end

    add_sortable_index :licenses
    add_index :licenses, :name, unique: true
    add_index :licenses, :short_name, unique: true
    add_index :licenses, :url, unique: true
  end
end
