module Dev

  class CreateUser
    lev_routine

    uses_routine OpenStax::Accounts::Dev::CreateUser,
                 as: :create_user,
                 translations: { outputs: {scope: :accounts} }
    uses_routine GetOrCreateUserFromAccount,
                 as: :get_or_create_user_from_account,
                 translations: { outputs: {type: :verbatim} }

  protected

    def exec(options={})
      run(:create_user,
          options.slice(:first_name, :last_name, :username, :ensure_no_errors))

      run(:get_or_create_user_from_account, outputs[[:accounts, :user]])
    end
  end

end
