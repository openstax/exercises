class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:become]
  skip_before_filter :require_registration!, only: [:registration, :register, :become]

  fine_print_skip_signatures :general_terms_of_use, 
                             :privacy_policy, 
                             only: [:registration, :register, :become]

  def register
    handle_with(UsersRegister,
                success: lambda { redirect_to root_path },
                failure: lambda { render 'registration' })
  end

  def become
    raise SecurityTransgression unless !Rails.env.production? || current_user.is_admin?
    sign_in(User.find(params[:id]))
    redirect_to request.referrer
  end
end
