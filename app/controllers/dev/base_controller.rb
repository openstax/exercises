# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module Dev
  class BaseController < ApplicationController

    before_filter :development_or_test!

    skip_interceptor :authenticate_user!
    fine_print_skip_signatures :general_terms_of_use, :privacy_policy

    protected

    def development_or_test!
      return if Rails.env.development? || Rails.env.test?
      raise SecurityTransgression
    end

  end
end
