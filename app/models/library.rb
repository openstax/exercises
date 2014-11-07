class Library < ActiveRecord::Base

  publishable

  has_one :required_library, dependent: :destroy

  has_many :logic_libraries, dependent: :destroy
  has_many :logics, through: :logic_libraries

  validates :language, presence: true, inclusion: { in: Language.all }

  scope :for, lambda { |language|
    where(language: language)
  }

  scope :required, lambda { joins(:required_library) }
  scope :not_required, lambda { joins{required_library.outer}
                                .where(required_library: {id: nil}) }

end
