class ApplicationController < ActionController::Base
  protect_from_forgery

  include SharedApplicationMethods

  helper OpenStax::Utilities::Engine.helpers

  layout :layout

  before_filter :authenticate_user!

  private

  def layout
    "application_body_only"
  end
end
