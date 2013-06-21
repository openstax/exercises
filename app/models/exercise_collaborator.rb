class ExerciseCollaborator < ActiveRecord::Base
  attr_accessible :exercise_collaborator_requests_count, :exercise_id, :is_author, :is_copyright_holder, :order, :user_id
end
