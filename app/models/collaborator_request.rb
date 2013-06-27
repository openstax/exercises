class ExerciseCollaboratorRequest < ActiveRecord::Base
  attr_accessible :exercise_collaborator_id, :requester_id, :toggle_is_author, :toggle_is_copyright_holder
end
