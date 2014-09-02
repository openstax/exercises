class Sort < ActiveRecord::Base

  belongs_to :domain, polymorphic: true
  belongs_to :sortable, polymorphic: true

  validates :domain, presence: true
  validates :sortable, presence: true, uniqueness: { scope: [:domain_id, :domain_type] }
  validates :position, presence: true, uniqueness: {
    scope: [:domain_id, :domain_type, :sortable_type] }

end
