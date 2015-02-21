OpenStax::Accounts.configure do |config|
  config.openstax_accounts_url = Rails.application.secrets[:openstax_accounts_url]
  config.openstax_application_id = Rails.application.secrets[:openstax_application_id]
  config.openstax_application_secret = Rails.application.secrets[:openstax_application_secret]
  config.logout_via = :delete
  config.account_user_mapper = UserMapper
  config.enable_stubbing = true
end
