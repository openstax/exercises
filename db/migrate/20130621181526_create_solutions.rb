class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :question_id, :null => false
      t.text :summary, :null => false, :default => ''
      t.text :content, :null => false, :default => ''
      t.text :content_html, :null => false, :default => ''
      t.integer :number, :null => false
      t.integer :version, :null => false, :default => 1
      t.datetime :published_at
      t.integer :license_id, :null => false

      t.timestamps
    end

    add_index :solutions, [:question_id, :number, :version], :unique => true
    add_index :solutions, :published_at
    add_index :solutions, :license_id
  end
end
