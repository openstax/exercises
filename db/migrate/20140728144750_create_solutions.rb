class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.references :question, null: false
      t.text :summary
      t.text :details, null: false, default: ''

      t.timestamps
    end

    add_index :solutions, :question_id
  end
end
