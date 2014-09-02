class Publication < ActiveRecord::Base

  sort_domain

  belongs_to :publishable, polymorphic: true
  belongs_to :license, inverse_of: :publications

  has_many :sources, class_name: 'Derivation', foreign_key: :derived_publication_id,
           dependent: :destroy, inverse_of: :derived_publication
  has_many :derivations, foreign_key: :source_publication_id,
           dependent: :destroy, inverse_of: :source_publication

  validates :publishable, presence: true, uniqueness: true
  validates :number, presence: true
  validates :version, presence: true, uniqueness: { scope: [:number, :publishable_type] }

  delegate_access_control_to :publishable

end
