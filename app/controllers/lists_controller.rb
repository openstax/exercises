class ListsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lists }
    end
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    @list = List.find(params[:id])
    raise_exception_unless(@list.can_be_read_by?(current_user))

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.json
  def new
    @list = List.new
    raise_exception_unless(@list.can_be_created_by?(current_user))

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
    raise_exception_unless(@list.can_be_updated_by?(current_user))
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(params[:list])
    raise_exception_unless(@list.can_be_created_by?(current_user))

    respond_to do |format|
      begin
        @list.transaction do
          @list.save!
          raise ActiveRecord::RecordInvalid unless @list.add_permission(current_user, :owner)
        end
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render json: @list, status: :created, location: @list }
      rescue ActiveRecord::RecordInvalid
        format.html { render action: "new" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.json
  def update
    @list = List.find(params[:id])
    raise_exception_unless(@list.can_be_updated_by?(current_user))

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list = List.find(params[:id])
    raise_exception_unless(@list.can_be_destroyed_by?(current_user))

    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url }
      format.json { head :no_content }
    end
  end
end
