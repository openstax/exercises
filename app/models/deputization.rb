class Deputization < ActiveRecord::Base

  sortable :deputizer

  belongs_to :deputizer, class_name: 'User', inverse_of: :child_deputizations
  belongs_to :deputy, polymorphic: true

  validates :deputy, presence: true
  validates :deputizer, presence: true, uniqueness: { scope: [:deputy_id, :deputy_type] }

end
