class TermsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  skip_before_filter :require_registration!, only: [:index, :show]
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy

  before_filter :get_contract, only: [:show]

  layout "layouts/application_body_only"

  def show
    # Hide old agreements (should never get them)
    raise ActiveRecord::RecordNotFound if !@contract.is_latest? && !current_user.is_administrator?
  end

  def pose
    @contract = FinePrint.get_contract(params['terms'].first)
  end

  def agree
    handle_with(TermsAgree,
                complete: lambda { fine_print_return })
  end

  protected

  def get_contract
    @contract = FinePrint.get_contract(params[:id])
  end
end
