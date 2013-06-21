class ExerciseDerivationsController < ApplicationController
  # GET /exercise_derivations
  # GET /exercise_derivations.json
  def index
    @exercise_derivations = ExerciseDerivation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exercise_derivations }
    end
  end

  # GET /exercise_derivations/1
  # GET /exercise_derivations/1.json
  def show
    @exercise_derivation = ExerciseDerivation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise_derivation }
    end
  end

  # GET /exercise_derivations/new
  # GET /exercise_derivations/new.json
  def new
    @exercise_derivation = ExerciseDerivation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise_derivation }
    end
  end

  # GET /exercise_derivations/1/edit
  def edit
    @exercise_derivation = ExerciseDerivation.find(params[:id])
  end

  # POST /exercise_derivations
  # POST /exercise_derivations.json
  def create
    @exercise_derivation = ExerciseDerivation.new(params[:exercise_derivation])

    respond_to do |format|
      if @exercise_derivation.save
        format.html { redirect_to @exercise_derivation, notice: 'Exercise derivation was successfully created.' }
        format.json { render json: @exercise_derivation, status: :created, location: @exercise_derivation }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise_derivation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /exercise_derivations/1
  # PUT /exercise_derivations/1.json
  def update
    @exercise_derivation = ExerciseDerivation.find(params[:id])

    respond_to do |format|
      if @exercise_derivation.update_attributes(params[:exercise_derivation])
        format.html { redirect_to @exercise_derivation, notice: 'Exercise derivation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise_derivation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_derivations/1
  # DELETE /exercise_derivations/1.json
  def destroy
    @exercise_derivation = ExerciseDerivation.find(params[:id])
    @exercise_derivation.destroy

    respond_to do |format|
      format.html { redirect_to exercise_derivations_url }
      format.json { head :no_content }
    end
  end
end
