class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.references :publishable, polymorphic: true, null: false
      t.references :license
      t.integer :number, null: false
      t.integer :version, null: false, default: 1
      t.datetime :published_at

      t.timestamps
    end

    add_index :publications, [:publishable_id, :publishable_type], unique: true
    add_index :publications, [:number, :publishable_type, :version], unique: true
    add_index :publications, :license_id
    add_index :publications, :published_at
  end
end
