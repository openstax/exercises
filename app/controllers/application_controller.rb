class ApplicationController < ActionController::Base
  protect_from_forgery

  include SharedApplicationMethods

  include Lev::HandleWith

  layout :layout

  before_filter :authenticate_user!

  protected

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
