class QuestionDependencyPairsController < ApplicationController
  # GET /questions/1/question_dependency_pairs/new
  # GET /questions/1/question_dependency_pairs/new.json
  def new
    @question_dependency_pair = QuestionDependencyPair.new
    raise_exception_unless(@question_dependency_pair.can_be_created_by?(current_user))

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question_dependency_pair }
    end
  end

  # POST /questions/1/question_dependency_pairs
  # POST /questions/1/question_dependency_pairs.json
  def create
    @question_dependency_pair = QuestionDependencyPair.new(params[:question_dependency_pair])
    raise_exception_unless(@question_dependency_pair.can_be_created_by?(current_user))

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

  # DELETE /question_dependency_pairs/1
  # DELETE /question_dependency_pairs/1.json
  def destroy
    @question_dependency_pair = QuestionDependencyPair.find(params[:id])
    raise_exception_unless(@question_dependency_pair.can_be_destroyed_by?(current_user))

    @question_dependency_pair.destroy

    respond_to do |format|
      format.html { redirect_to question_dependency_pairs_url }
      format.json { head :no_content }
    end
  end
end
