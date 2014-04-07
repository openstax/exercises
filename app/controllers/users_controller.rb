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

end
