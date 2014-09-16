class Library < ActiveRecord::Base

  publishable

  belongs_to :language, inverse_of: :libraries

  has_one :required_library, dependent: :destroy, inverse_of: :library

  has_many :logic_libraries, dependent: :destroy, inverse_of: :library
  has_many :logics, through: :logic_libraries

  validates :language, presence: true

  scope :for, lambda { |language|
    joins(:language).where(language: {name: language})
  }

  scope :required, lambda { joins(:required_library) }
  scope :not_required, lambda { joins{required_library.outer}
                              .where(required_library: {id: nil}) }

end
