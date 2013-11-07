module Dev
  class UsersCreate
    lev_handler

    paramify :create do
      attribute :first_name, type: String
      attribute :last_name, type: String
      attribute :username, type: String
      attribute :is_admin, type: boolean

      validates :username, presence: true
    end

    uses_routine Dev::CreateUser,
                 translations: { inputs: { scope: :create },
                                 outputs: { type: :verbatim } }

  protected

    def authorized?
      !Rails.env.production?
    end

    def handle
      run(Dev::CreateUser, create_params.as_hash(:first_name, :last_name, :username))
      outputs[:user].update_attribute(:is_admin, create_params.is_admin)
    end

  end 
end