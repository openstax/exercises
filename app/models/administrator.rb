class Administrator < ActiveRecord::Base

  belongs_to :user, inverse_of: :administrators

  validates :user, presence: true, uniqueness: true

end
