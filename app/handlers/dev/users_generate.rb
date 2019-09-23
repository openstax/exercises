module Dev
  class UsersGenerate

    lev_handler

    paramify :generate do
      attribute :count, type: Integer
      validates :count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    end

    protected

    def authorized?
      !Rails.env.production?
    end

    def handle
      outputs[:users] = []
      generate_params.count.times do
        outputs[:users] << FactoryBot.create(:user, :agreed_to_terms)
      end
      outputs[:count] = generate_params.count
    end

  end
end
