class RegisterUser
  lev_routine

protected

  def exec(user, options={})
    response = OpenStax::Accounts.create_application_user(user.openstax_accounts_user)
    # Probably not necessary to check the response status,
    # since it just throws exceptions on failure,
    # which will result in HTTP 500 errors.
    fatal_error(code: :no_app_user, message: 'Could not contact the Accounts server. Please try again.') unless response.status == 201

    user.update_attributes({is_registered: true}, without_protection: true)
  end

end