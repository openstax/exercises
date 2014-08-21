module UserMapper
  def self.account_to_user(account)
    GetOrCreateUserFromAccount.call(account).outputs.user
  end

  def self.user_to_account(user)
    user.is_anonymous? ? OpenStax::Accounts::Account.anonymous : \
                         user.account
  end
end
