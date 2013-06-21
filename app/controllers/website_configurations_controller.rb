class WebsiteConfigurationsController < ApplicationController
  # GET /website_configurations
  # GET /website_configurations.json
  def index
    @website_configurations = WebsiteConfiguration.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @website_configurations }
    end
  end

  # GET /website_configurations/1
  # GET /website_configurations/1.json
  def show
    @website_configuration = WebsiteConfiguration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @website_configuration }
    end
  end

  # GET /website_configurations/new
  # GET /website_configurations/new.json
  def new
    @website_configuration = WebsiteConfiguration.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @website_configuration }
    end
  end

  # GET /website_configurations/1/edit
  def edit
    @website_configuration = WebsiteConfiguration.find(params[:id])
  end

  # POST /website_configurations
  # POST /website_configurations.json
  def create
    @website_configuration = WebsiteConfiguration.new(params[:website_configuration])

    respond_to do |format|
      if @website_configuration.save
        format.html { redirect_to @website_configuration, notice: 'Website configuration was successfully created.' }
        format.json { render json: @website_configuration, status: :created, location: @website_configuration }
      else
        format.html { render action: "new" }
        format.json { render json: @website_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /website_configurations/1
  # PUT /website_configurations/1.json
  def update
    @website_configuration = WebsiteConfiguration.find(params[:id])

    respond_to do |format|
      if @website_configuration.update_attributes(params[:website_configuration])
        format.html { redirect_to @website_configuration, notice: 'Website configuration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @website_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /website_configurations/1
  # DELETE /website_configurations/1.json
  def destroy
    @website_configuration = WebsiteConfiguration.find(params[:id])
    @website_configuration.destroy

    respond_to do |format|
      format.html { redirect_to website_configurations_url }
      format.json { head :no_content }
    end
  end
end
