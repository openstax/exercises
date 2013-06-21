class AttachableAssetsController < ApplicationController
  # GET /attachable_assets
  # GET /attachable_assets.json
  def index
    @attachable_assets = AttachableAsset.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachable_assets }
    end
  end

  # GET /attachable_assets/1
  # GET /attachable_assets/1.json
  def show
    @attachable_asset = AttachableAsset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attachable_asset }
    end
  end

  # GET /attachable_assets/new
  # GET /attachable_assets/new.json
  def new
    @attachable_asset = AttachableAsset.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachable_asset }
    end
  end

  # GET /attachable_assets/1/edit
  def edit
    @attachable_asset = AttachableAsset.find(params[:id])
  end

  # POST /attachable_assets
  # POST /attachable_assets.json
  def create
    @attachable_asset = AttachableAsset.new(params[:attachable_asset])

    respond_to do |format|
      if @attachable_asset.save
        format.html { redirect_to @attachable_asset, notice: 'Attachable asset was successfully created.' }
        format.json { render json: @attachable_asset, status: :created, location: @attachable_asset }
      else
        format.html { render action: "new" }
        format.json { render json: @attachable_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachable_assets/1
  # PUT /attachable_assets/1.json
  def update
    @attachable_asset = AttachableAsset.find(params[:id])

    respond_to do |format|
      if @attachable_asset.update_attributes(params[:attachable_asset])
        format.html { redirect_to @attachable_asset, notice: 'Attachable asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attachable_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachable_assets/1
  # DELETE /attachable_assets/1.json
  def destroy
    @attachable_asset = AttachableAsset.find(params[:id])
    @attachable_asset.destroy

    respond_to do |format|
      format.html { redirect_to attachable_assets_url }
      format.json { head :no_content }
    end
  end
end
