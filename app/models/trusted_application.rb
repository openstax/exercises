class TrustedApplication < ApplicationRecord

  belongs_to :application, class_name: 'Doorkeeper::Application',
                           inverse_of: :trusted_application

  validates :application, uniqueness: true

end
