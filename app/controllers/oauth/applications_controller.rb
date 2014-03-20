module Oauth
  class ApplicationsController < Doorkeeper::ApplicationsController
    skip_before_filter :authenticate_admin!
    before_filter :authenticate_user!
    before_filter :get_user
    before_filter :get_user_group, :only => [:index, :new, :create]
    before_filter :get_application, :except => [:index, :new, :create]

    def index
      AccessPolicy.require_action_allowed!(:read, @user, @user_group)
      @applications = @user_group.oauth_applications
    end

    def new
      @application = Doorkeeper::Application.new
      @application.owner = @user_group
      AccessPolicy.require_action_allowed!(:create, @user, @application)
    end

    def create
      @application = Doorkeeper::Application.new(application_params)
      @application.owner = @user_group
      AccessPolicy.require_action_allowed!(:create, @user, @application)
      @application.trusted = params[:application][:trusted] if @user.is_admin?
      if @application.save
        flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash,
                                                    :applications, :create])
        respond_with [:oauth, @application]
      else
        render :new
      end
    end
    
    def show
      AccessPolicy.require_action_allowed!(:read, @user, @application)
      super
    end

    def edit
      AccessPolicy.require_action_allowed!(:update, @user, @application)
      super
    end

    def update
      AccessPolicy.require_action_allowed!(:update, @user, @application)
      if @application.update_attributes(application_params)
        @application.update_attribute(:trusted, params[:application][:trusted]) \
          if @user.is_admin?
        flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash,
                                                    :applications, :update])
        respond_with [:oauth, @application]
      else
        render :edit
      end
    end

    def destroy
      AccessPolicy.require_action_allowed!(:destroy, @user, @application)
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash,
                                                  :applications, :destroy]) \
                         if @application.destroy
      redirect_to user_group_oauth_applications_url(@application.owner)
    end

    protected

    def get_user
      @user = current_user
    end

    def get_user_group
      @user_group = UserGroup.find(params[:user_group_id])
    end
    
    def get_application
      @application = Doorkeeper::Application.find(params[:id])
    end

    private
    
    def application_params
      if params.respond_to?(:permit)
        params.require(:application).permit(:name, :redirect_uri)
      else
        params[:application].slice(:name, :redirect_uri) rescue nil
      end
    end
  end
end