class QuestionDependencyPairsController < ApplicationController
  before_filter :get_question, :only => [:new, :create]

  # GET /questions/1/question_dependency_pairs/new
  # GET /questions/1/question_dependency_pairs/new.json
  def new
    @question_dependency_pair = QuestionDependencyPair.new
    @question_dependency_pair.dependent_question = @question

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question_dependency_pair }
    end
  end

  # POST /questions/1/question_dependency_pairs
  # POST /questions/1/question_dependency_pairs.json
  def create
    @question_dependency_pair = QuestionDependencyPair.new(params[:question_dependency_pair].select{|k, v| k == 'kind'})
    @question_dependency_pair.dependent_question = @question
    @question_dependency_pair.independent_question = Question.find(params[:question_dependency_pair][:independent_question_id])

    respond_to do |format|
      if @question_dependency_pair.save
        format.html { redirect_to @question.exercise, notice: 'Question dependency pair was successfully created.' }
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
      format.html { redirect_to @question_dependency_pair.dependent_question.exercise }
      format.json { head :no_content }
    end
  end

  protected

  def get_question
    @question = Question.find(params[:question_id])
    raise_exception_unless(@question.can_be_updated_by?(current_user))
  end
end
