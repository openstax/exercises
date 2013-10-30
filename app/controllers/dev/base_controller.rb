module Dev
  class BaseController < ApplicationController

    skip_before_filter :authenticate_user!
    skip_before_filter :require_registration!
    skip_before_filter :require_agreement_to_terms!

    before_filter Proc.new{ 
      raise SecurityTransgression unless !Rails.env.production?
    }
    
  end
end
