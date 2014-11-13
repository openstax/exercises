class Logic < ActiveRecord::Base

  sort_domain

  belongs_to :parent, polymorphic: true

  has_many :logic_libraries, dependent: :destroy
  has_many :libraries, through: :logic_libraries

  has_many :logic_variables, dependent: :destroy
  has_many :logic_variable_values, through: :logic_variables

  validates :parent, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: Language.all }

end
