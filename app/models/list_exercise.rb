class ListExercise < ActiveRecord::Base
  numberable

  attr_accessible :list, :exercise

  belongs_to :list
  belongs_to :exercise

  after_destroy :destroy_listless_draft_exercise

  validates_presence_of :list, :exercise
  validates_uniqueness_of :exercise_id, :scope => :list_id
  validates_uniqueness_of :exercise_id, 
                          :unless => Proc.new { |wq| wq.exercise.is_published? }

  ##################
  # Access Control #
  ##################

  protected

  #############
  # Callbacks #
  #############

  def destroy_listless_draft_exercise
    exercise.destroy if (!exercise.is_published? && exercise.list_exercises.empty?)
  end
end
