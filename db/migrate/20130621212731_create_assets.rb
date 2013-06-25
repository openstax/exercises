class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_uploaded_at
      t.integer :uploader_id

      t.timestamps
    end

    add_index :assets, :uploader_id
  end
end
