class AdminController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
  end

  protected

  def authenticate_admin!
    raise_exception_unless_admin
  end
end
