class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true, null: false
      t.string :asset, null: false

      t.timestamps
    end

    add_index :attachments, [:attachable_id, :attachable_type, :asset], unique: true,
              name: 'index_attachments_on_a_id_and_a_type_and_asset'
    add_index :attachments, :asset
  end
end
