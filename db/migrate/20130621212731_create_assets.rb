class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :file
      t.text :caption
      t.text :alt
      t.integer :attachable_id
      t.string :attachable_type
      t.string :local_name

      t.timestamps
    end

    add_index :assets, [:attachable_type, :attachable_id, :local_name], :unique => true
  end
end
