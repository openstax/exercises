class TrueOrFalseAnswersController < ApplicationController
  # GET /true_or_false_answers
  # GET /true_or_false_answers.json
  def index
    @true_or_false_answers = TrueOrFalseAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @true_or_false_answers }
    end
  end

  # GET /true_or_false_answers/1
  # GET /true_or_false_answers/1.json
  def show
    @true_or_false_answer = TrueOrFalseAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @true_or_false_answer }
    end
  end

  # GET /true_or_false_answers/new
  # GET /true_or_false_answers/new.json
  def new
    @true_or_false_answer = TrueOrFalseAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @true_or_false_answer }
    end
  end

  # GET /true_or_false_answers/1/edit
  def edit
    @true_or_false_answer = TrueOrFalseAnswer.find(params[:id])
  end

  # POST /true_or_false_answers
  # POST /true_or_false_answers.json
  def create
    @true_or_false_answer = TrueOrFalseAnswer.new(params[:true_or_false_answer])

    respond_to do |format|
      if @true_or_false_answer.save
        format.html { redirect_to @true_or_false_answer, notice: 'True or false answer was successfully created.' }
        format.json { render json: @true_or_false_answer, status: :created, location: @true_or_false_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @true_or_false_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /true_or_false_answers/1
  # PUT /true_or_false_answers/1.json
  def update
    @true_or_false_answer = TrueOrFalseAnswer.find(params[:id])

    respond_to do |format|
      if @true_or_false_answer.update_attributes(params[:true_or_false_answer])
        format.html { redirect_to @true_or_false_answer, notice: 'True or false answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @true_or_false_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /true_or_false_answers/1
  # DELETE /true_or_false_answers/1.json
  def destroy
    @true_or_false_answer = TrueOrFalseAnswer.find(params[:id])
    @true_or_false_answer.destroy

    respond_to do |format|
      format.html { redirect_to true_or_false_answers_url }
      format.json { head :no_content }
    end
  end
end
