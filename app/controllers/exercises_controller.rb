class ExercisesController < ApplicationController

  before_filter :set_exercise

  # GET /exercises/1
  def show
  end

  protected

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

end
