class DerivationsController < ApplicationController
  before_filter :get_publishable, :only => [:new, :create]

  # GET /publishables/1/derivations/new
  # GET /publishables/1/derivations/new.json
  def new
    case publishable_type
    when 'Exercise'
      exercise_search
    when 'Solution'
      solution_search
    end
  end

  # POST /publishables/1/derivations
  # POST /publishables/1/derivations.json
  def create
    publishable_class = @publishable.class
    source_publishable = publishable_class.find(params[:source_publishable_id])

    @derivation = @publishable.add_source(source_publishable)
    respond_to do |format|
      if @derivation.persisted?
        format.html { redirect_to @publishable, notice: 'Source was successfully added to list.' }
        format.json { render json: @derivation, status: :created, location: @derivation }
      else
        format.html do
          case publishable_class.name
          when 'Exercise'
            exercise_search_error_html
          when 'Solution'
            solution_search_error_html
          end
        end
        format.json { render json: @derivation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /derivations/1
  # DELETE /derivations/1.json
  def destroy
    @derivation = Derivation.find(params[:id])
    raise_exception_unless(@derivation.can_be_destroyed_by?(current_user))

    @derivation.destroy

    respond_to do |format|
      format.html { redirect_to @derivation.derived_publishable }
      format.json { head :no_content }
    end
  end

  protected

  def get_publishable
    @publishable = params[:exercise_id] ? Exercise.from_param(params[:exercise_id]) :
                   (params[:solution_id] ? Solution.from_param(params[:solution_id]) : nil)
    raise_exception_unless(!@publishable.nil? && @publishable.can_be_updated_by?(current_user))
    publishable_type = @publishable.class.name
  end
end
