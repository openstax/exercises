class CreateExerciseCollaboratorRequests < ActiveRecord::Migration
  def change
    create_table :exercise_collaborator_requests do |t|
      t.integer :exercise_collaborator_id
      t.integer :requester_id
      t.boolean :toggle_is_author
      t.boolean :toggle_is_copyright_holder

      t.timestamps
    end
  end
end
