class Administrator < ApplicationRecord

  belongs_to :user

  validates :user, presence: true, uniqueness: true

end
