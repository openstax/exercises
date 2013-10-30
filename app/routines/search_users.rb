class SearchUsers
  lev_routine transaction: :no_transaction

protected

  def exec(terms, type=:any)
    # Return all results if no search terms
    if terms.blank?
      outputs[:users] = User.scoped
      return
    end

    # Note: % is the wildcard. This allows the user to search
    # for stuff that "begins with" but not "ends with".

    users = User.joins(:openstax_connect_user)

    case type
    when :name
      terms.gsub(/[%,]/, '').split.each do |t|
        next if t.blank?
        query = t + '%'
        users = users.where{(openstax_connect_user.first_name =~ query) | 
                            (openstax_connect_user.last_name =~ query)}
      end
    when :username
      query = terms.gsub('%', '') + '%'
      users = users.where{openstax_connect_user.username =~ query}
    when :any
      terms.gsub(/[%,]/, '').split.each do |t|
        next if t.blank?
        query = t + '%'
        users = users.where{(openstax_connect_user.first_name =~ query) | 
                            (openstax_connect_user.last_name =~ query) |
                            (openstax_connect_user.username =~ query)}
      end
    else
      fatal_error(:unknown_user_search_type, data: type)
    end

    outputs[:users] = users
  end
end