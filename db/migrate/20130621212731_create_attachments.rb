class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :number
      t.string :asset
      t.text :caption
      t.text :alt
      t.integer :attachable_id
      t.string :attachable_type
      t.string :local_name

      t.timestamps
    end

    add_index :attachments, [:attachable_type, :attachable_id, :local_name], :unique => true, :name => "index_a_on_a_type_and_a_id_and_l_name"
    add_index :attachments, :number
  end
end
