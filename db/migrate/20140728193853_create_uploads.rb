class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.sortable
      t.references :uploader, polymorphic: true, null: false
      t.string :asset, null: false

      t.timestamps
    end

    add_index :uploads, :asset, unique: true
    add_index :uploads, [:uploader_id, :uploader_type, :position], unique: true
  end
end
