class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.references :publishable, polymorphic: true, null: false
      t.references :license
      t.integer :number, null: false
      t.integer :version, null: false, default: 1
      t.datetime :published_at
      t.datetime :embargo_until
      t.boolean :embargo_children_only, null: false, default: false
      t.boolean :is_major_change, null: false, default: false

      t.timestamps
    end

    add_index :publications, [:publishable_id, :publishable_type], unique: true
    add_index :publications, [:number, :publishable_type, :version], unique: true
    add_index :publications, :license_id
    add_index :publications, :published_at
    add_index :publications, :embargo_until
    add_index :publications, :embargo_children_only
  end
end
