class MatchingAnswersController < ApplicationController
  # GET /matching_answers
  # GET /matching_answers.json
  def index
    @matching_answers = MatchingAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matching_answers }
    end
  end

  # GET /matching_answers/1
  # GET /matching_answers/1.json
  def show
    @matching_answer = MatchingAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @matching_answer }
    end
  end

  # GET /matching_answers/new
  # GET /matching_answers/new.json
  def new
    @matching_answer = MatchingAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @matching_answer }
    end
  end

  # GET /matching_answers/1/edit
  def edit
    @matching_answer = MatchingAnswer.find(params[:id])
  end

  # POST /matching_answers
  # POST /matching_answers.json
  def create
    @matching_answer = MatchingAnswer.new(params[:matching_answer])

    respond_to do |format|
      if @matching_answer.save
        format.html { redirect_to @matching_answer, notice: 'Matching answer was successfully created.' }
        format.json { render json: @matching_answer, status: :created, location: @matching_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @matching_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /matching_answers/1
  # PUT /matching_answers/1.json
  def update
    @matching_answer = MatchingAnswer.find(params[:id])

    respond_to do |format|
      if @matching_answer.update_attributes(params[:matching_answer])
        format.html { redirect_to @matching_answer, notice: 'Matching answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @matching_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matching_answers/1
  # DELETE /matching_answers/1.json
  def destroy
    @matching_answer = MatchingAnswer.find(params[:id])
    @matching_answer.destroy

    respond_to do |format|
      format.html { redirect_to matching_answers_url }
      format.json { head :no_content }
    end
  end
end
