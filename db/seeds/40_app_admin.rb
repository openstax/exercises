unless OpenStax::Accounts::Account.where(username: 'ose_app_admin').exists?
  admin_account = OpenStax::Accounts::FindOrCreateAccount.call(
    username: 'ose_app_admin'
  ).outputs.account

  User.create!(account: admin_account).create_administrator!
end
