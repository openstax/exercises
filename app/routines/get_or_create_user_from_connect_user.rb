class GetOrCreateUserFromConnectUser
  lev_routine

  uses_routine CreateUser,
               translations: { outputs: {type: :verbatim} }

protected

  def exec(connect_user, options={})    
    return outputs[:user] = User.anonymous if connect_user.is_anonymous?

    existing_user = User.where(openstax_connect_user_id: connect_user.id).first
    return outputs[:user] = existing_user if existing_user.present?

    run(CreateUser, connect_user)
  end
end