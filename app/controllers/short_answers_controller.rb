class ShortAnswersController < ApplicationController
  # GET /short_answers
  # GET /short_answers.json
  def index
    @short_answers = ShortAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @short_answers }
    end
  end

  # GET /short_answers/1
  # GET /short_answers/1.json
  def show
    @short_answer = ShortAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @short_answer }
    end
  end

  # GET /short_answers/new
  # GET /short_answers/new.json
  def new
    @short_answer = ShortAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @short_answer }
    end
  end

  # GET /short_answers/1/edit
  def edit
    @short_answer = ShortAnswer.find(params[:id])
  end

  # POST /short_answers
  # POST /short_answers.json
  def create
    @short_answer = ShortAnswer.new(params[:short_answer])

    respond_to do |format|
      if @short_answer.save
        format.html { redirect_to @short_answer, notice: 'Short answer was successfully created.' }
        format.json { render json: @short_answer, status: :created, location: @short_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @short_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /short_answers/1
  # PUT /short_answers/1.json
  def update
    @short_answer = ShortAnswer.find(params[:id])

    respond_to do |format|
      if @short_answer.update_attributes(params[:short_answer])
        format.html { redirect_to @short_answer, notice: 'Short answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @short_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /short_answers/1
  # DELETE /short_answers/1.json
  def destroy
    @short_answer = ShortAnswer.find(params[:id])
    @short_answer.destroy

    respond_to do |format|
      format.html { redirect_to short_answers_url }
      format.json { head :no_content }
    end
  end
end
