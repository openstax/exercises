class FreeResponsesController < ApplicationController
  # GET /free_responses
  # GET /free_responses.json
  def index
    @free_responses = FreeResponse.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @free_responses }
    end
  end

  # GET /free_responses/1
  # GET /free_responses/1.json
  def show
    @free_response = FreeResponse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @free_response }
    end
  end

  # GET /free_responses/new
  # GET /free_responses/new.json
  def new
    @free_response = FreeResponse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @free_response }
    end
  end

  # GET /free_responses/1/edit
  def edit
    @free_response = FreeResponse.find(params[:id])
  end

  # POST /free_responses
  # POST /free_responses.json
  def create
    @free_response = FreeResponse.new(params[:free_response])

    respond_to do |format|
      if @free_response.save
        format.html { redirect_to @free_response, notice: 'Free response was successfully created.' }
        format.json { render json: @free_response, status: :created, location: @free_response }
      else
        format.html { render action: "new" }
        format.json { render json: @free_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /free_responses/1
  # PUT /free_responses/1.json
  def update
    @free_response = FreeResponse.find(params[:id])

    respond_to do |format|
      if @free_response.update_attributes(params[:free_response])
        format.html { redirect_to @free_response, notice: 'Free response was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @free_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /free_responses/1
  # DELETE /free_responses/1.json
  def destroy
    @free_response = FreeResponse.find(params[:id])
    @free_response.destroy

    respond_to do |format|
      format.html { redirect_to free_responses_url }
      format.json { head :no_content }
    end
  end
end
