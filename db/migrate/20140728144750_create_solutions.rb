class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.publishable
      t.references :question, null: false
      t.text :summary, null: false, default: ''
      t.text :details, null: false, default: ''

      t.timestamps
    end

    add_publishable_indexes :solutions
    add_index :solutions, :question_id
  end
end
