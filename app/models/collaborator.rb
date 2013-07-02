class ExerciseCollaborator < ActiveRecord::Base
  numberable

  attr_accessible :toggle_author_request, :toggle_copyright_holder_request

  belongs_to :user
  belongs_to :collaborable, :polymorphic => true
  belongs_to :requester, :class_name => 'User'

  ##########################
  # Access control methods #
  ##########################
end
