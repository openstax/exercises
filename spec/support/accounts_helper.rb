module AccountsHelper
  def sign_in(user)
    post openstax_accounts.become_dev_account_url(user.account_id)
    follow_redirect!
  end

  def sign_out!
    destroy openstax_accounts.logout_url
    follow_redirect!
  end
end
