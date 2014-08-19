class CreatePublishableLicenses < ActiveRecord::Migration
  def change
    create_table :publishable_licenses do |t|
      t.references :publishable, polymorphic: true, null: false
      t.references :license, null: false
      t.datetime :start_at, null: false
      t.boolean :request_attribution, null: false

      t.timestamps
    end

    add_index :publishable_licenses, [:license_id, :publishable_id, :publishable_type],
                                      unique: true
    add_index :publishable_licenses, [:publishable_id, :publishable_type, :start_at]
  end
end
