class Deputization < ActiveRecord::Base

  sortable

  belongs_to :deputizer, class_name: 'User'
  belongs_to :deputy, polymorphic: true

  validates :deputy, presence: true
  validates :deputizer, presence: true,
                        uniqueness: { scope: [:deputy_id, :deputy_type] }

end
