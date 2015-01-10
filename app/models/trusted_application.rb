class TrustedApplication < ActiveRecord::Base

  belongs_to :application, class_name: 'Doorkeeper::Application',
                           inverse_of: :trusted_application

  validates :application, presence: true, uniqueness: true

end
