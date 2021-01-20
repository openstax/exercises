class StaticPagesController < ApplicationController
  respond_to :html

  skip_before_action :authenticate_user!

  fine_print_skip :general_terms_of_use, :privacy_policy
end
