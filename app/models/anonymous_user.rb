class AnonymousUser

  include Singleton

  delegate :username, :first_name, :last_name, :full_name, :title,
           :name, :casual_name, to: :account

  def account
    OpenStax::Accounts::AnonymousAccount.instance
  end

  def is_human?
    true
  end
  
  def is_application?
    false
  end

  def is_anonymous?
    true
  end

end
