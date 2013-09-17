class AdminController < ApplicationController
  before_filter :authenticate_admin!

  protected

  def authenticate_admin!
    raise_exception_unless_admin
  end
end
