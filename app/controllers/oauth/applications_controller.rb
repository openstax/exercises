module Oauth
  class ApplicationsController < Doorkeeper::ApplicationsController
    before_action :set_user

    def index
      @applications = @user.is_administrator? ? Doorkeeper::Application.ordered_by(:created_at) :
                                                @user.applications.sort_by(&:created_at)

      respond_to do |format|
        format.html
        format.json { head :no_content }
      end
    end

    def show
      OSU::AccessPolicy.require_action_allowed!(:read, @user, @application)

      respond_to do |format|
        format.html
        format.json { render json: @application }
      end
    end

    def new
      @application = Doorkeeper::Application.new
      OSU::AccessPolicy.require_action_allowed!(:create, @user, @application)
    end

    def create
      @application = Doorkeeper::Application.new(application_params(@user))
      @application.owner = current_user

      OSU::AccessPolicy.require_action_allowed!(:create, @user, @application)

      if @application.save
        flash[:notice] = I18n.t(
          :notice, scope: %i[doorkeeper flash applications create]
        )
        respond_to do |format|
          format.html { redirect_to oauth_application_url(@application) }
          format.json { render json: @application }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json do
            render json: { errors: @application.errors.full_messages },
                   status: :unprocessable_entity
          end
        end
      end
    end

    def edit
      OSU::AccessPolicy.require_action_allowed!(:update, @user, @application)
    end

    def update
      OSU::AccessPolicy.require_action_allowed!(:update, @user, @application)

      app_params = application_params(@user)
      if @application.update(app_params)
        flash[:notice] = I18n.t(
          :notice, scope: %i[doorkeeper flash applications update]
        )
        respond_to do |format|
          format.html { redirect_to oauth_application_url(@application) }
          format.json { render json: @application }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json do
            render json: { errors: @application.errors.full_messages },
                   status: :unprocessable_entity
          end
        end
      end
    end

    def destroy
      OSU::AccessPolicy.require_action_allowed!(:destroy, @user, @application)

      if @application.destroy
        flash[:notice] = I18n.t(
          :notice, scope: %i[doorkeeper flash applications destroy]
        )
      end

      respond_to do |format|
        format.html { redirect_to oauth_applications_url }
        format.json { head :no_content }
      end
    end

    private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes)
    end

    def admin_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes, :confidential)
    end

    # We control which attributes of Doorkeeper::Applications can be updated
    # here, since they differ for normal users and administrators
    def application_params(user)
      user.is_administrator? ? admin_params : user_params
    end
  end
end
