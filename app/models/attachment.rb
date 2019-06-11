class Attachment < ApplicationRecord

  mount_uploader :asset, AssetUploader

  belongs_to :parent, polymorphic: true, inverse_of: :attachments, touch: true

  before_update { raise ActiveRecord::ReadOnlyRecord } # Prevent updates

  validates :asset, presence: true
  validate :unique_asset

  def filename
    new_record? ? asset.filename : read_attribute(:asset)
  end

  protected

  def remove_asset!
    super unless Attachment.where(asset: filename).exists?
  end

  def unique_asset
    return if asset.nil? || parent.nil?
    return unless Attachment.where.not(id: id).where({parent_id: parent.id, asset: asset.identifier}).exists?
    errors.add(:asset, 'has already been associated with this resource')
    throw(:abort)
  end

end
