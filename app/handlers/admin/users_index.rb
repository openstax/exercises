module Admin
  class UsersIndex

    lev_handler transaction: :no_transaction

    paramify :search do
      attribute :terms, type: String
      attribute :type, type: String
      attribute :page, type: Integer
      attribute :per_page, type: Integer
    end

    uses_routine OpenStax::Accounts::Dev::SearchAccounts,
                 as: :search_users,
                 translations: { outputs: {type: :verbatim} }

    protected

    def authorized?
      true
    end

    def handle
      return if search_params.terms.nil?

      prefix = case search_params.type
      when 'Name'
        'name:'
      when 'Username'
        'username:'
      else
        prefix = ''
      end
      names = search_params.terms.split(/\s/)
      query = names.collect{|name| "#{prefix}#{name}"}.join(' ').to_s
      run(:search_users, query, page: search_params.page,
                                per_page: search_params.per_page)
    end

  end
end
