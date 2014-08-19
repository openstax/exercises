class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.publishable
      t.references :question, null: false
      t.references :logic
      t.text :summary
      t.text :details, null: false

      t.timestamps
    end

    add_publishable_indexes :solutions, :question_id
    add_index :solutions, :logic_id
  end
end
