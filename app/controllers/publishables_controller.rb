class PublishablesController < ApplicationController
  before_filter :get_publishables

  # GET /publishables/1/publication_agreement
  def publication_agreement
    @license = @publishables.first.license
    @licenses_differ = @publishables.any?{|p| p.license != @license}

    respond_to do |format|
      format.html # agreement.html.erb
      #format.json { render json: @publishables }
    end
  end

  # POST /publishables/1/publish
  def publish
    unless @errors.blank?
      respond_to do |format|
        format.html { redirect_to :back, alert: 'Please fix the following errors before publishing:' }
        #format.json { render json: @errors, status: :unprocessable_entity }
      end

      return
    end

    unless params[:agreement_accepted]
      respond_to do |format|
        format.html { redirect_to :back, alert: 'You must accept the license agreement before publishing.' }
        #format.json { render json: 'You must accept the license agreement before publishing.', status: :unprocessable_entity }
      end

      return
    end

    ActiveRecord::Base.transaction do
      @publishables.each { |e| e.publish! }
    end
      
    respond_to do |format|
      format.html # publish.html.erb
      #format.json { head :no_content }
    end
  end

  protected

  def merge_errors(publishables)
    errors = {}

    publishables.each do |p|
      errors = errors.merge(p.errors){|k, o, n| o + n}
    end

    errors
  end

  def get_publishables
    @publishables = []

    @exercise_ids = params[:exercise_ids] || []
    @exercise_ids << params[:exercise_id] unless params[:exercise_id].blank?

    @solution_ids = params[:solution_ids] || []
    @solution_ids << params[:solution_id] unless params[:solution_id].blank?

    @publishables += @exercise_ids.collect{|eid| Exercise.find(eid)} unless @exercise_ids.blank?
    @publishables += @solution_ids.collect{|eid| Solution.find(eid)} unless @solution_ids.blank?

    raise SecurityTransgression if @publishables.blank?
    @publishables.each do |p|
      raise_exception_unless(p.can_be_published_by?(current_user))
      p.run_prepublish_checks
    end

    @errors = merge_errors(@publishables)
  end
end
