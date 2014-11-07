class Administrator < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true, uniqueness: true

end
