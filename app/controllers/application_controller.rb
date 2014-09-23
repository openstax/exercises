class ApplicationController < ActionController::Base

  respond_to :html, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Lev::HandleWith

  layout 'application_body_only'

  interceptor :authenticate_user!

  before_filter :not_destroyed!

  fine_print_require :general_terms_of_use, :privacy_policy

  protected

  def not_destroyed!
    return if current_user.try(:destroyed_at).nil?
    sign_out
    redirect_to home_url
  end

end
