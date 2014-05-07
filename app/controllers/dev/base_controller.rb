# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module Dev
  class BaseController < ApplicationController

    before_filter Proc.new{
      raise SecurityTransgression if Rails.env.production?
    }

    skip_before_filter :authenticate_user!
    skip_before_filter :require_registration!

    fine_print_skip_signatures :general_terms_of_use,
                               :privacy_policy

  end
end
