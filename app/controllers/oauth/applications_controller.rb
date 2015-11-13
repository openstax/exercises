module Oauth
  class ApplicationsController < Doorkeeper::ApplicationsController
    before_filter :set_user
    before_filter :set_application, only: [:show, :edit, :update, :destroy]

    def index
      @applications = @user.administrator ? Doorkeeper::Application.all : @user.applications
    end

    def new
      OSU::AccessPolicy.require_action_allowed!(:create, @user, Doorkeeper::Application)
      super
    end

    def create
      OSU::AccessPolicy.require_action_allowed!(:create, @user, Doorkeeper::Application)
      @application = Doorkeeper::Application.new(application_params)
      @application.owner = OpenStax::Accounts::CreateGroup[owner: current_user.account]

      if @application.save
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])
        redirect_to oauth_application_url(@application)
      else
        render :new
      end
    end

    def show
      OSU::AccessPolicy.require_action_allowed!(:read, @user, @application)
    end

    def edit
      OSU::AccessPolicy.require_action_allowed!(:update, @user, @application)
    end

    def update
      OSU::AccessPolicy.require_action_allowed!(:update, @user, @application)
      if @application.update_attributes(application_params)
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :update])
        redirect_to oauth_application_url(@application)
      else
        render :edit
      end
    end

    def destroy
      OSU::AccessPolicy.require_action_allowed!(:destroy, @user, @application)
      super
    end

    protected

    def set_user
      @user = current_user
    end

    def set_application
      @application = Doorkeeper::Application.find(params[:id])
    end

    def application_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :email_subject_prefix)
    end
  end
end
