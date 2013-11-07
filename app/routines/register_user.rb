class RegisterUser
  lev_routine

protected

  def exec(user, options={})
    user.update_attributes({is_registered: true}, without_protection: true)
  end

end