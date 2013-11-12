class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.text :markup
      t.text :html
      t.integer :attachable_id

      t.timestamps
    end
    add_index :contents, :attachable_id
  end
end
