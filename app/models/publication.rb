class Publication < ActiveRecord::Base

  belongs_to :publishable, polymorphic: true
  belongs_to :license, inverse_of: :publications

  validates :publishable, presence: true, uniqueness: true
  validates :number, presence: true
  validates :version, presence: true, uniqueness: { scope: [:number, :publishable_type] }

end
