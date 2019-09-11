module Admin
  class BaseController < ApplicationController

    skip_before_action :authenticate_user! if Rails.env.development?
    before_action :authenticate_admin! unless Rails.env.development?

    fine_print_skip :general_terms_of_use, :privacy_policy

    layout "layouts/admin"

    protected

    def authenticate_admin!
      raise SecurityTransgression unless current_user.is_administrator?
    end

  end
end
