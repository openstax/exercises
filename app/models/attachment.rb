# Record of old attachments (old tutor-deployment, Carrierwave)
class Attachment < ApplicationRecord
  belongs_to :parent, polymorphic: true, inverse_of: :attachments, touch: true

  before_update { raise ActiveRecord::ReadOnlyRecord if changed? } # Prevent updates

  validates :asset, presence: true
  validate :unique_asset

  def filename
    asset
  end

  protected

  def unique_asset
    return if asset.nil? || parent.nil?
    return unless Attachment.where.not(id: id).where(parent_id: parent.id, asset: asset).exists?
    errors.add(:asset, 'has already been associated with this resource')
    throw(:abort)
  end
end
