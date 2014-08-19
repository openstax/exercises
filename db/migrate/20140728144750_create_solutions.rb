class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.publishable
      t.logicable
      t.references :question, null: false
      t.text :summary
      t.text :details, null: false

      t.timestamps
    end

    add_publishable_indexes :solutions, :question_id
    add_logicable_index :solutions
  end
end
