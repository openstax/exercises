class Library < ActiveRecord::Base

  publishable
  has_collaborators

  belongs_to :language, inverse_of: :libraries

  has_one :required_library, dependent: :destroy, inverse_of: :library

  has_many :logic_libraries, dependent: :destroy, inverse_of: :library
  has_many :logics, through: :logic_libraries

  validates :language, presence: true

  scope :for, lambda { |language|
    joins(:language).where(language: {name: language})
  }

end
