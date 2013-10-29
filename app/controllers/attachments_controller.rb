class AttachmentsController < ApplicationController
  before_filter :get_attachable, :only => [:new, :create]

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
    raise_exception_unless(@attachment.can_be_updated_by?(current_user))
  end

  # POST /attachments
  # POST /attachments.json
  def create
    asset = params[:attachment].delete(:asset)
    @attachment = Attachment.new(params[:attachment])
    @attachment.attachable = @attachable
    @attachment.asset = asset

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachable, notice: 'Attachment was successfully created.' }
        format.json { render json: @attachment, status: :created, location: @attachment }
      else
        format.html { render action: "new" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])
    raise_exception_unless(@attachment.can_be_updated_by?(current_user))

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to @attachment.attachable, notice: 'Attachment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find(params[:id])
    raise_exception_unless(@attachment.can_be_destroyed_by?(current_user))

    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to @attachment.attachable }
      format.json { head :no_content }
    end
  end

  protected

  def get_attachable
    @attachable = params[:solution_id] ? Solution.from_param(params[:solution_id]) :
                  (params[:exercise_id] ? Exercise.from_param(params[:exercise_id]) : nil)
    raise_exception_unless(!@attachable.nil? && @attachable.can_be_updated_by?(current_user))
  end
end
