module Admin
  class BaseController < ApplicationController

    before_filter :authenticate_admin!

    skip_before_filter :authenticate_user!
    fine_print_skip :general_terms_of_use, :privacy_policy

    protected

    def authenticate_admin!
      return if !Rails.env.production? ||\
                (authenticate_user! && current_user.administrator)
      raise SecurityTransgression
    end

  end
end
