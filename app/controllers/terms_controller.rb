class TermsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index, :show]
  skip_before_filter :require_registration!, only: [:index, :show]
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy

  before_filter :get_contract, only: [:show]

  layout "layouts/application_body_only"

  def index
    @contracts = FinePrint::Agreement.latest
  end

  def show
    # Hide old agreements for the moment
    raise ActiveRecord::RecordNotFound if !@contract.is_latest? && !current_user.is_administrator?
  end

  def pose
    @contract = FinePrint::Utilities.latest_contract_named(params['terms'].first)
  end

  def agree
    handle_with(TermsAgree,
                complete: lambda { redirect_to session.delete(:fine_print_return_to) || root_path })
  end

protected

  def get_contract
    @contract = FinePrint::Contract.find(params[:id])
  end

end