class Logic < ActiveRecord::Base

  belongs_to :parent, polymorphic: true

  has_many :logic_libraries, dependent: :destroy

  has_many :logic_variables, dependent: :destroy

  validates :parent, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: Language.all }

end
