class UsersRegister
  lev_handler

  paramify :register do
    attribute :i_agree, type: boolean
    attribute :contract_1_id, type: Integer
    validates :contract_1_id, presence: true
    attribute :contract_2_id, type: Integer
    validates :contract_2_id, presence: true
  end

  uses_routine RegisterUser
  uses_routine AgreeToTerms

protected

  def authorized?
    !caller.is_registered?
  end

  def handle
    # In addition to doing whatever is needed to register a user, this page / handler
    # also gives the user a shortcut for agreeing to common site terms.

    if !register_params.i_agree
      fatal_error(code: :did_not_agree, message: 'You must agree to the terms to register') 
    end

    run(RegisterUser, caller)
    run(AgreeToTerms, register_params.contract_1_id, caller)
    run(AgreeToTerms, register_params.contract_2_id, caller)
  end
end