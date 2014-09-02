class ApplicationController < ActionController::Base

  protect_from_forgery

  include Lev::HandleWith

  layout :application_body_only

  interceptor :authenticate_user!

  before_filter :not_destroyed!

  fine_print_get_signatures :general_terms_of_use, :privacy_policy

  protected

  def not_destroyed!
    return if current_user.try(:destroyed_at).nil?
    sign_out
    redirect_to home_url
  end

end
