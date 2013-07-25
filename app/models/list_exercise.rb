class ListExercise < ActiveRecord::Base
  sortable :list_id

  belongs_to :list, :inverse_of => :list_exercises
  belongs_to :exercise, :inverse_of => :list_exercises

  attr_accessible :list, :exercise

  after_destroy :destroy_unlisted_draft_exercise

  validates_presence_of :list, :exercise
  validates_uniqueness_of :exercise_id, :scope => :list_id
  validates_uniqueness_of :exercise_id, 
                          :unless => Proc.new { |wq| wq.exercise.is_published? }

  ##################
  # Access Control #
  ##################

  def can_be_created_by?(user)
    list.has_permission?(user, :editor) || \
    list.has_permission?(user, :publisher) || \
    list.has_permission?(user, :manager)
  end

  def can_be_destroyed_by?(user)
    can_be_created_by?(user)
  end

  protected

  #############
  # Callbacks #
  #############

  def destroy_unlisted_draft_exercise
    exercise.destroy if (!exercise.is_published? && exercise.list_exercises.empty?)
  end
end
