class ApplicationController < ActionController::Base
  protect_from_forgery

  include SharedApplicationMethods

  helper OpenStax::Utilities::Engine.helpers

  layout :layout

  before_filter :authenticate_user!

  protected

  def raise_unless(authorized)
    return if authorized || user_is_admin?
    raise SecurityTransgression
  end

  private

  def layout
    "application_body_only"
  end
end
