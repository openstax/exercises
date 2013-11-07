class GetOrCreateUserFromConnectUser
  lev_routine

protected

  def exec(connect_user, options={})
    outputs[:user] = connect_user.is_anonymous? ?
                       User.anonymous :
                       (User.where(openstax_connect_user_id: connect_user.id).first ||
                        User.create do |user|
                          user.openstax_connect_user_id = connect_user.id
                          user.is_registered = false
                        end)
  end
end