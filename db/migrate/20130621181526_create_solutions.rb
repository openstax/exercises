class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.content [:summary, :content]
      t.publishable
      t.belongs_to :exercise, null: false

      t.timestamps
    end

    add_publishable_indexes :solutions
    add_index :solutions, :exercise_id
  end
end
