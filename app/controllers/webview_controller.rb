class WebviewController < ApplicationController

  respond_to :html

  layout :resolve_layout

  skip_before_action :authenticate_user!, only: :home
  fine_print_skip :general_terms_of_use, :privacy_policy, only: :home

  def home
  end

  def index
    @path = params[:path] || '/'
    @name = current_user.casual_name
  end

  protected

  def resolve_layout
    'home' == action_name ? 'application_body_only' : 'webview'
  end

end
