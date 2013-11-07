class ApplicationController < ActionController::Base
  protect_from_forgery

  include SharedApplicationMethods

  include Lev::HandleWith

  layout :layout

  before_filter :authenticate_user!
  before_filter :require_registration!

  fine_print_get_signatures :general_terms_of_use, 
                            :privacy_policy

protected

  def require_registration!
    redirect_to users_registration_path if signed_in? && !current_user.is_registered?
  end

  def raise_exception_unless_admin
    return if user_is_admin?
    raise SecurityTransgression
  end

  def raise_exception_unless(authorized)
    return if authorized
    raise_exception_unless_admin
  end

  def authenticate_admin!
    raise SecurityTransgression unless signed_in? && current_user.is_admin?
  end

  private

  def layout
    "application_body_only"
  end
end
