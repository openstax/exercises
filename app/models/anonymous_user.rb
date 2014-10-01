class AnonymousUser

  include Singleton

  def id
    nil
  end

  def account
    OpenStax::Accounts::AnonymousAccount.instance
  end

  def account_id
    nil
  end

  def username
    'Anonymous'
  end

  def is_anonymous?
    true
  end

  def is_deleted?
    false
  end

end
