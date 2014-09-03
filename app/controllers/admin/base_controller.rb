module Admin
  class BaseController < ApplicationController

    before_filter :authenticate_admin!

    skip_interceptor :authenticate_user!
    fine_print_skip_signatures :general_terms_of_use, :privacy_policy

    def index
    end

    protected

    def authenticate_admin!
      return if !Rails.env.production? ||\
                (authenticate_user! && current_user.administrator.exists?)
      raise SecurityTransgression
    end

  end
end
