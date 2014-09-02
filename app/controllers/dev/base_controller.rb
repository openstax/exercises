# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module Dev
  class BaseController < ApplicationController

    before_filter :not_production

    skip_before_filter :authenticate_user!

    fine_print_skip_signatures :general_terms_of_use, :privacy_policy

    protected

    def not_production
      return unless Rails.env.production?
      raise SecurityTransgression
    end

  end
end
