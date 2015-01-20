class WebviewController < ApplicationController

  respond_to :html

  layout :resolve_layout

  skip_interceptor :authenticate_user!, only: :home
  fine_print_skip :general_terms_of_use, :privacy_policy, only: :home

  def home
    #redirect_to dashboard_path unless current_user.is_anonymous?
  end

  def index
    @name = current_user.casual_name
    @path = path
  end

  protected

  def resolve_layout
    'application_body_only'
    #'home' == action_name ? 'application_body_only' : 'webview'
  end

end
