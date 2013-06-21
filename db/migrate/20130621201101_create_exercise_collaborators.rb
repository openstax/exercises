class CreateExerciseCollaborators < ActiveRecord::Migration
  def change
    create_table :exercise_collaborators do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.integer :order
      t.boolean :is_author
      t.boolean :is_copyright_holder
      t.integer :exercise_collaborator_requests_count

      t.timestamps
    end
  end
end
