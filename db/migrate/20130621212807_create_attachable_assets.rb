class CreateAttachableAssets < ActiveRecord::Migration
  def change
    create_table :attachable_assets do |t|
      t.integer :attachable_id
      t.integer :asset_id
      t.string :local_name
      t.text :description
      t.string :attachable_type

      t.timestamps
    end
  end
end
