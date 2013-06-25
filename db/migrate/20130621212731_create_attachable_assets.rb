class CreateAttachableAssets < ActiveRecord::Migration
  def change
    create_table :attachable_assets do |t|
      t.string :asset
      t.text :caption
      t.text :alt
      t.integer :attachable_id
      t.string :attachable_type
      t.string :local_name

      t.timestamps
    end

    add_index :attachable_assets, [:attachable_type, :attachable_id, :local_name], :unique => true
    add_index :attachable_assets, :asset
  end
end
