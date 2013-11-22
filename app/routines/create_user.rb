class CreateUser
  lev_routine

protected

  def exec(connect_user, options={})

    # Create the new user's default list

    default_list = List.create(:name => "#{connect_user.name}'s default list")
    
    # Create the user

    outputs[:user] = User.create do |user|
      user.openstax_connect_user_id = connect_user.id
      user.is_registered = false
      user.default_list = default_list
    end

    # Make sure the user has permissions in his own list

    default_list.add_permission(outputs[:user], :owner)

    # Create the user's deputy group

    UserGroup.create do |deputy_user_group|
      deputy_user_group.name = "Deputies"
      deputy_user_group.container = outputs[:user]
    end

  end
end