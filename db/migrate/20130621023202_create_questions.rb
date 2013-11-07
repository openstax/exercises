class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.content
      t.credit
      t.sortable
      t.belongs_to :exercise, null: false

      t.timestamps
    end

    add_sortable_index :questions, :exercise_id
  end
end
