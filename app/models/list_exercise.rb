class ListExercise < ActiveRecord::Base
  sortable :list_id

  belongs_to :list, :inverse_of => :list_exercises
  belongs_to :exercise, :inverse_of => :list_exercises

  attr_accessible :list, :exercise

  after_destroy :destroy_unlisted_draft_exercise

  validates_presence_of :list, :exercise
  validates_uniqueness_of :exercise_id, :scope => :list_id, :unless => :is_published?

  def is_published?
    exercise.is_published?
  end

  ##################
  # Access Control #
  ##################

  def can_be_created_by?(user)
    list.can_be_edited_by?(user)
  end

  def can_be_destroyed_by?(user)
    list.can_be_edited_by?(user)
  end

  protected

  #############
  # Callbacks #
  #############

  def destroy_unlisted_draft_exercise
    exercise.destroy if (!is_published? && exercise.list_exercises.empty?)
  end
end
