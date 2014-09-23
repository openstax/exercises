class Language < ActiveRecord::Base

  has_many :logics, dependent: :destroy, inverse_of: :language
  has_many :libraries, dependent: :destroy, inverse_of: :language

  validates :name, presence: true, uniqueness: true

end
