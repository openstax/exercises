module Dev
  class UsersCreate

    lev_handler

    paramify :create do
      attribute :username, type: String
      attribute :first_name, type: String
      attribute :last_name, type: String
      attribute :full_name, type: String
      attribute :title, type: String
      attribute :is_administrator, type: boolean
      attribute :agreed_to_terms, type: boolean

      validates :username, presence: true
    end

    protected

    def authorized?
      !Rails.env.production?
    end

    def handle
      create_symbols = []
      create_symbols << :administrator if create_params.is_administrator
      create_symbols << :agreed_to_terms if create_params.agreed_to_terms
      create_hash = create_params.as_hash(:username, :first_name, :last_name, :full_name, :title)
      outputs[:user] = FactoryBot.create(:user, *create_symbols, create_hash)
    end

  end
end
