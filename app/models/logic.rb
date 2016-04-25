class Logic < ActiveRecord::Base

  belongs_to :parent, polymorphic: true, inverse_of: :logic

  has_many :logic_variables, dependent: :destroy

  validates :parent, presence: true
  validates :parent_id, uniqueness: { scope: :parent_type }
  validates :language, presence: true, inclusion: { in: Language.all }
  validates :code, presence: true

end
