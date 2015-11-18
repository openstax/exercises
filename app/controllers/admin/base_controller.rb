module Admin
  class BaseController < ApplicationController

    skip_before_filter :authenticate_user! unless Rails.env.production?
    before_filter :authenticate_admin! if Rails.env.production?

    fine_print_skip :general_terms_of_use, :privacy_policy

    protected

    def authenticate_admin!
      raise SecurityTransgression unless current_user.is_administrator?
    end

  end
end
