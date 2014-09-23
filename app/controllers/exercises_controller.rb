class ExercisesController < ApplicationController

  before_filter :set_exercise
  fine_print_skip :general_terms_of_use, :privacy_policy, only: :show

  # GET /exercises/1
  def show
  end

  protected

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

end
