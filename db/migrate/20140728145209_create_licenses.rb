class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.sortable
      t.string :name, null: false
      t.string :short_name, null: false
      t.string :url, null: false
      t.text :contract, null: false
      t.text :notice, null: false
      t.text :can_combine_into, null: false, default: [].to_yaml
      t.text :allowed_publishables, null: false,
             default: ['Exercise', 'Solution', 'Rubric'].to_yaml
      t.boolean :is_public_domain, null: false, default: false

      t.timestamps
    end

    add_sortable_index :licenses
    add_index :licenses, :name, unique: true
    add_index :licenses, :short_name, unique: true
    add_index :licenses, :url, unique: true
  end
end
