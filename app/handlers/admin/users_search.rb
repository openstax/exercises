module Admin
  class UsersSearch
    
    lev_handler transaction: :no_transaction
    
    paramify :search do
      attribute :search_terms, type: String
      attribute :search_page, type: Integer
    end
    
    uses_routine SearchUsers,
    as: :search_users,
    translations: { outputs: {type: :verbatim} }
    
    protected
    
    def authorized?
      !Rails.env.production? || caller.is_admin?
    end
    
    def handle
      run(:search_users, search_params.search_terms, page: search_params.search_page || 0)
    end
    
  end
end