module Admin
  class UsersSearch
    lev_handler transaction: :no_transaction

    paramify :search do
      attribute :type, type: String
      attribute :query, type: String
      attribute :order_by, type: String
      attribute :per_page, type: Integer
      attribute :page, type: Integer
    end

    uses_routine OpenStax::Accounts::SearchAccounts,
                 as: :search_users,
                 translations: { outputs: {type: :verbatim} }

    protected

    def authorized?
      true
    end

    def handle
      prefix = case search_params.type
      when 'Name'
        'name:'
      when 'Username'
        'username:'
      else
        prefix = ''
      end
      names = (search_params.query || '').split(/\s/)
      query = names.map { |name| "#{prefix}#{name}" }.join(' ').to_s

      run(:search_users, query, search_params.order_by, search_params.per_page, search_params.page)
    end
  end
end
