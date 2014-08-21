class CreateUser
  lev_routine

  protected

  def exec(account, options={})
    
    # Create the user

    outputs[:user] = User.create do |user|
      user.account_id = account.id
      user.is_registered = false
    end

  end
end