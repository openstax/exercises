class ApplicationController < ActionController::Base

  protect_from_forgery

  include Lev::HandleWith

  layout :application_body_only

  before_filter :authenticate_user!, :not_destroyed!

  fine_print_get_signatures :general_terms_of_use, :privacy_policy

  protected

  def authenticate_user!
    super
    return if current_user.destroyed_at.nil?
    sign_out
    redirect_to home_url
  end

end
