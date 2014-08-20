class PublishablesController < ApplicationController
  before_filter :get_publishables, :only => [:publication_agreement, :publish]
  before_filter :get_publishable, :only => [:new_version, :derive]

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

  # POST /publishables/1/new_version
  # POST /publishables/1/new_version.json
  def new_version
    raise_exception_unless(@publishable.new_version_can_be_created_by?(current_user))

    respond_to do |format|
      begin
        @publishable.transaction do
          @new_version = @publishable.new_version
          raise ActiveRecord::RecordInvalid.new(@publishable) unless @list.nil? || @list.add_exercise(@new_version)
        end
        format.html { redirect_to @new_version, notice: "New version of #{@publishable.name} was successfully created." }
        format.json { render json: @new_version, status: :created, location: @new_version }
      rescue ActiveRecord::RecordInvalid
        format.html { redirect_to @publishable, alert: "New version could not be created." }
        format.json { render json: @publishable.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /publishables/1/derive
  # POST /publishables/1/derive.json
  def derive
    raise_exception_unless(@publishable.can_be_derived_by?(current_user))

    respond_to do |format|
      begin
        @publishable.transaction do
          @derived_publishable = @publishable.derive_for(current_user)
          raise ActiveRecord::RecordInvalid.new(@publishable) unless @list.nil? || @list.add_exercise(@derived_publishable)
        end
        format.html { redirect_to @derived_publishable, notice: "Derivation of #{@publishable.name} was successfully created." }
        format.json { render json: @derived_publishable, status: :created, location: @derived_publishable }
      rescue ActiveRecord::RecordInvalid
        format.html { redirect_to @publishable, alert: "Derivation could not be created." }
        format.json { render json: @publishable.errors, status: :unprocessable_entity }
      end
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

  def get_publishable
    @publishable = params[:solution_id] ? Solution.from_param(params[:solution_id]) :
                   (params[:exercise_id] ? Exercise.from_param(params[:exercise_id]) : nil)
    raise_exception_unless(!@publishable.nil?)
    if @publishable.class == Exercise
      @list = params[:list_id].nil? ? current_user.default_list : List.find(params[:list_id])
      raise_exception_unless(@list.can_be_edited_by?(current_user))
    end
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
