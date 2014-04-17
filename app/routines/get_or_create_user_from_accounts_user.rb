class GetOrCreateUserFromAccountsUser
  lev_routine

  uses_routine CreateUser,
               translations: { outputs: {type: :verbatim} }

protected

  def exec(accounts_user, options={})
    return outputs[:user] = User.anonymous if accounts_user.is_anonymous?

    existing_user = User.where(openstax_accounts_user_id: accounts_user.id).first
    return outputs[:user] = existing_user if existing_user.present?

    run(CreateUser, accounts_user)
  end
end