class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :question_id
      t.text :content
      t.text :content_html
      t.text :summary
      t.integer :number
      t.integer :version
      t.datetime :published_at
      t.integer :source_solution_id

      t.timestamps
    end

    add_index :solutions, [:question_id, :number, :version], :unique => true
    add_index :solutions, :published_at
    add_index :solutions, :source_solution_id
  end
end
