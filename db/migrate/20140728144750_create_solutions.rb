class CreateSolutions < ActiveRecord::Migration[4.2]
  def change
    create_table :solutions do |t|
      t.references :question, null: false
      t.string :title
      t.text :solution_type, null: false
      t.text :content, null: false

      t.timestamps null: false
    end

    add_index :solutions, :question_id
    add_index :solutions, :title
    add_index :solutions, :solution_type
  end
end
