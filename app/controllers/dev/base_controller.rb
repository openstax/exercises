# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module Dev
  class BaseController < Admin::BaseController

    before_filter Proc.new{
      raise SecurityTransgression if Rails.env.production?
    }

  end
end
