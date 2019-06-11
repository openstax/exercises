class CreateAttachments < ActiveRecord::Migration[4.2]
  def change
    create_table :attachments do |t|
      t.references :parent, polymorphic: true, null: false
      t.string :asset, null: false

      t.timestamps null: false

      t.index [:parent_id, :parent_type, :asset], unique: true
      t.index :asset
    end
  end
end
