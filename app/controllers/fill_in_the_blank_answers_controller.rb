class FillInTheBlankAnswersController < ApplicationController
  # GET /fill_in_the_blank_answers
  # GET /fill_in_the_blank_answers.json
  def index
    @fill_in_the_blank_answers = FillInTheBlankAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fill_in_the_blank_answers }
    end
  end

  # GET /fill_in_the_blank_answers/1
  # GET /fill_in_the_blank_answers/1.json
  def show
    @fill_in_the_blank_answer = FillInTheBlankAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fill_in_the_blank_answer }
    end
  end

  # GET /fill_in_the_blank_answers/new
  # GET /fill_in_the_blank_answers/new.json
  def new
    @fill_in_the_blank_answer = FillInTheBlankAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fill_in_the_blank_answer }
    end
  end

  # GET /fill_in_the_blank_answers/1/edit
  def edit
    @fill_in_the_blank_answer = FillInTheBlankAnswer.find(params[:id])
  end

  # POST /fill_in_the_blank_answers
  # POST /fill_in_the_blank_answers.json
  def create
    @fill_in_the_blank_answer = FillInTheBlankAnswer.new(params[:fill_in_the_blank_answer])

    respond_to do |format|
      if @fill_in_the_blank_answer.save
        format.html { redirect_to @fill_in_the_blank_answer, notice: 'Fill in the blank answer was successfully created.' }
        format.json { render json: @fill_in_the_blank_answer, status: :created, location: @fill_in_the_blank_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @fill_in_the_blank_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fill_in_the_blank_answers/1
  # PUT /fill_in_the_blank_answers/1.json
  def update
    @fill_in_the_blank_answer = FillInTheBlankAnswer.find(params[:id])

    respond_to do |format|
      if @fill_in_the_blank_answer.update_attributes(params[:fill_in_the_blank_answer])
        format.html { redirect_to @fill_in_the_blank_answer, notice: 'Fill in the blank answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fill_in_the_blank_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fill_in_the_blank_answers/1
  # DELETE /fill_in_the_blank_answers/1.json
  def destroy
    @fill_in_the_blank_answer = FillInTheBlankAnswer.find(params[:id])
    @fill_in_the_blank_answer.destroy

    respond_to do |format|
      format.html { redirect_to fill_in_the_blank_answers_url }
      format.json { head :no_content }
    end
  end
end
