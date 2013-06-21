class MultipleChoiceAnswersController < ApplicationController
  # GET /multiple_choice_answers
  # GET /multiple_choice_answers.json
  def index
    @multiple_choice_answers = MultipleChoiceAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @multiple_choice_answers }
    end
  end

  # GET /multiple_choice_answers/1
  # GET /multiple_choice_answers/1.json
  def show
    @multiple_choice_answer = MultipleChoiceAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @multiple_choice_answer }
    end
  end

  # GET /multiple_choice_answers/new
  # GET /multiple_choice_answers/new.json
  def new
    @multiple_choice_answer = MultipleChoiceAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @multiple_choice_answer }
    end
  end

  # GET /multiple_choice_answers/1/edit
  def edit
    @multiple_choice_answer = MultipleChoiceAnswer.find(params[:id])
  end

  # POST /multiple_choice_answers
  # POST /multiple_choice_answers.json
  def create
    @multiple_choice_answer = MultipleChoiceAnswer.new(params[:multiple_choice_answer])

    respond_to do |format|
      if @multiple_choice_answer.save
        format.html { redirect_to @multiple_choice_answer, notice: 'Multiple choice answer was successfully created.' }
        format.json { render json: @multiple_choice_answer, status: :created, location: @multiple_choice_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @multiple_choice_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /multiple_choice_answers/1
  # PUT /multiple_choice_answers/1.json
  def update
    @multiple_choice_answer = MultipleChoiceAnswer.find(params[:id])

    respond_to do |format|
      if @multiple_choice_answer.update_attributes(params[:multiple_choice_answer])
        format.html { redirect_to @multiple_choice_answer, notice: 'Multiple choice answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @multiple_choice_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /multiple_choice_answers/1
  # DELETE /multiple_choice_answers/1.json
  def destroy
    @multiple_choice_answer = MultipleChoiceAnswer.find(params[:id])
    @multiple_choice_answer.destroy

    respond_to do |format|
      format.html { redirect_to multiple_choice_answers_url }
      format.json { head :no_content }
    end
  end
end
