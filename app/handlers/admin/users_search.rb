module Admin
  class UsersSearch

    lev_handler transaction: :no_transaction

    paramify :search do
      attribute :terms, type: String
      attribute :type, type: String
      attribute :page, type: Integer
    end

    uses_routine SearchUsers,
                 as: :search_users,
                 translations: { outputs: {type: :verbatim} }

    protected

    def authorized?
      !Rails.env.production? || caller.is_admin?
    end

    def handle
      case search_params.type
      when 'Name'
        query = "name:#{search_params.terms.gsub(/\s/,',')}"
      when 'Username'
        query = "username:#{search_params.terms.gsub(/\s/,',')}"
      else
        query = search_params.terms
      end
      run(:search_users, query, page: search_params.page || 0)
    end

  end
end
