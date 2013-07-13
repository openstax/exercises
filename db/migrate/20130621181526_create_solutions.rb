class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :question_id, :null => false
      t.text :summary, :null => false, :default => ''
      t.text :content, :null => false, :default => ''
      t.text :content_html, :null => false, :default => ''
      t.integer :source_solution_id
      t.integer :number, :null => false
      t.integer :version, :null => false
      t.datetime :published_at
      t.integer :license_id

      t.timestamps
    end

    add_index :solutions, [:question_id, :number, :version], :unique => true
    add_index :solutions, :source_solution_id
    add_index :solutions, :published_at
    add_index :solutions, :license_id
  end
end
