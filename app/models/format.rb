class Format < ActiveRecord::Base

  has_many :formattings, dependent: :destroy, inverse_of: :format

  validates :name, presence: true, uniqueness: true

end
