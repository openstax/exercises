class GetOrCreateUserFromAccount
  lev_routine

  uses_routine CreateUser,
               as: :create_user,
               translations: { outputs: {type: :verbatim} }

  protected

  def exec(account, options={})
    return outputs[:user] = User.anonymous if account.is_anonymous?

    existing_user = User.find_by(account_id: account.id)
    return outputs[:user] = existing_user if existing_user.present?

    run(:create_user, account)
  end
end