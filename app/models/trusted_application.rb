class TrustedApplication < ActiveRecord::Base

  belongs_to :application, class_name: 'Doorkeeper::Application'

  validates :application, presence: true, uniqueness: true

end
