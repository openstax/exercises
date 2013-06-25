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

    add_index :attachable_assets, [:attachable_id, :attachable_type, :local_name], :unique => true, :name => "index_aa_on_a_id_and_a_type_and_l_name"
  end
end
