class ListExercise < ActiveRecord::Base
  numberable

  belongs_to :list
  belongs_to :exercise

  after_destroy :destroy_listless_draft_exercise

  validates_uniqueness_of :exercise_id, 
                          :unless => Proc.new { |wq| wq.exercise.is_published? }
  validates_uniqueness_of :exercise_id, :scope => :list_id

  protected

  def destroy_listless_draft_exercise
    exercise.destroy if (!exercise.is_published? && exercise.list_exercises.empty?)
  end

  public

  ##########################
  # Access control methods #
  ##########################
end
