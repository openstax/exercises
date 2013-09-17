class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.integer :position, :null => false
      t.string :name, :null => false, :default => ''
      t.string :short_name, :null => false, :default => ''
      t.string :url, :null => false, :default => ''
      t.string :partial_filename, :null => false, :default => ''

      t.timestamps
    end

    add_index :licenses, :position, :unique => true
    add_index :licenses, :name, :unique => true
    add_index :licenses, :short_name, :unique => true
    add_index :licenses, :url, :unique => true
  end
end
