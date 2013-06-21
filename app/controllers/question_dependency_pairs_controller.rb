class QuestionDependencyPairsController < ApplicationController
  # GET /question_dependency_pairs
  # GET /question_dependency_pairs.json
  def index
    @question_dependency_pairs = QuestionDependencyPair.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @question_dependency_pairs }
    end
  end

  # GET /question_dependency_pairs/1
  # GET /question_dependency_pairs/1.json
  def show
    @question_dependency_pair = QuestionDependencyPair.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question_dependency_pair }
    end
  end

  # GET /question_dependency_pairs/new
  # GET /question_dependency_pairs/new.json
  def new
    @question_dependency_pair = QuestionDependencyPair.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question_dependency_pair }
    end
  end

  # GET /question_dependency_pairs/1/edit
  def edit
    @question_dependency_pair = QuestionDependencyPair.find(params[:id])
  end

  # POST /question_dependency_pairs
  # POST /question_dependency_pairs.json
  def create
    @question_dependency_pair = QuestionDependencyPair.new(params[:question_dependency_pair])

    respond_to do |format|
      if @question_dependency_pair.save
        format.html { redirect_to @question_dependency_pair, notice: 'Question dependency pair was successfully created.' }
        format.json { render json: @question_dependency_pair, status: :created, location: @question_dependency_pair }
      else
        format.html { render action: "new" }
        format.json { render json: @question_dependency_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /question_dependency_pairs/1
  # PUT /question_dependency_pairs/1.json
  def update
    @question_dependency_pair = QuestionDependencyPair.find(params[:id])

    respond_to do |format|
      if @question_dependency_pair.update_attributes(params[:question_dependency_pair])
        format.html { redirect_to @question_dependency_pair, notice: 'Question dependency pair was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question_dependency_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /question_dependency_pairs/1
  # DELETE /question_dependency_pairs/1.json
  def destroy
    @question_dependency_pair = QuestionDependencyPair.find(params[:id])
    @question_dependency_pair.destroy

    respond_to do |format|
      format.html { redirect_to question_dependency_pairs_url }
      format.json { head :no_content }
    end
  end
end
