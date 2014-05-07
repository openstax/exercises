module Dev

  class CreateUser
    lev_routine

    uses_routine OpenStax::Accounts::Dev::CreateUser,
                 translations: { outputs: {scope: :accounts} }
    uses_routine GetOrCreateUserFromAccountsUser,
                 translations: { outputs: {type: :verbatim} }

  protected

    def exec(options={})
      run(OpenStax::Accounts::Dev::CreateUser,
          options.slice(:first_name, :last_name, :username, :ensure_no_errors))

      run(GetOrCreateUserFromAccountsUser, outputs[[:accounts, :user]])
    end
  end

end
