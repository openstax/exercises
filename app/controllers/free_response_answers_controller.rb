class FreeResponseAnswersController < ApplicationController
  # GET /free_response_answers
  # GET /free_response_answers.json
  def index
    @free_response_answers = FreeResponseAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @free_response_answers }
    end
  end

  # GET /free_response_answers/1
  # GET /free_response_answers/1.json
  def show
    @free_response_answer = FreeResponseAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @free_response_answer }
    end
  end

  # GET /free_response_answers/new
  # GET /free_response_answers/new.json
  def new
    @free_response_answer = FreeResponseAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @free_response_answer }
    end
  end

  # GET /free_response_answers/1/edit
  def edit
    @free_response_answer = FreeResponseAnswer.find(params[:id])
  end

  # POST /free_response_answers
  # POST /free_response_answers.json
  def create
    @free_response_answer = FreeResponseAnswer.new(params[:free_response_answer])

    respond_to do |format|
      if @free_response_answer.save
        format.html { redirect_to @free_response_answer, notice: 'Free response answer was successfully created.' }
        format.json { render json: @free_response_answer, status: :created, location: @free_response_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @free_response_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /free_response_answers/1
  # PUT /free_response_answers/1.json
  def update
    @free_response_answer = FreeResponseAnswer.find(params[:id])

    respond_to do |format|
      if @free_response_answer.update_attributes(params[:free_response_answer])
        format.html { redirect_to @free_response_answer, notice: 'Free response answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @free_response_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /free_response_answers/1
  # DELETE /free_response_answers/1.json
  def destroy
    @free_response_answer = FreeResponseAnswer.find(params[:id])
    @free_response_answer.destroy

    respond_to do |format|
      format.html { redirect_to free_response_answers_url }
      format.json { head :no_content }
    end
  end
end
