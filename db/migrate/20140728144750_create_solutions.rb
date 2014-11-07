class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.references :question, null: false
      t.string :title
      t.text :summary
      t.text :details, null: false

      t.timestamps null: false
    end

    add_index :solutions, :question_id
    add_index :solutions, :title
  end
end
