class DeputizationsController < ApplicationController
  # GET /deputizations
  # GET /deputizations.json
  def index
    @deputizations = Deputization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @deputizations }
    end
  end

  # GET /deputizations/1
  # GET /deputizations/1.json
  def show
    @deputization = Deputization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deputization }
    end
  end

  # GET /deputizations/new
  # GET /deputizations/new.json
  def new
    @deputization = Deputization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deputization }
    end
  end

  # GET /deputizations/1/edit
  def edit
    @deputization = Deputization.find(params[:id])
  end

  # POST /deputizations
  # POST /deputizations.json
  def create
    @deputization = Deputization.new(params[:deputization])

    respond_to do |format|
      if @deputization.save
        format.html { redirect_to @deputization, notice: 'Deputization was successfully created.' }
        format.json { render json: @deputization, status: :created, location: @deputization }
      else
        format.html { render action: "new" }
        format.json { render json: @deputization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deputizations/1
  # PUT /deputizations/1.json
  def update
    @deputization = Deputization.find(params[:id])

    respond_to do |format|
      if @deputization.update_attributes(params[:deputization])
        format.html { redirect_to @deputization, notice: 'Deputization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deputization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deputizations/1
  # DELETE /deputizations/1.json
  def destroy
    @deputization = Deputization.find(params[:id])
    @deputization.destroy

    respond_to do |format|
      format.html { redirect_to deputizations_url }
      format.json { head :no_content }
    end
  end
end
