class Attachment < ActiveRecord::Base

  belongs_to :parent, polymorphic: true

  validates :parent, presence: true
  validates :asset, presence: true,
                    uniqueness: { scope: [:parent_type, :parent_id] }

end
