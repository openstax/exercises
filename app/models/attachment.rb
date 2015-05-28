class Attachment < ActiveRecord::Base

  mount_uploader :asset, AssetUploader

  belongs_to :parent, polymorphic: true

  validates :asset, presence: true
  validates :parent, presence: true
  validate :unique_asset

  protected

  def remove_asset!
    super unless Attachment.where(asset: asset.file.try(:filename)).exists?
  end

  def remove_previously_stored_asset
    super unless Attachment.where(asset: asset_was.file.try(:filename)).exists?
  end

  def unique_asset
    return if asset.nil? || parent.nil?
    return unless Attachment.where{(id != my{id}) & \
                                   (parent == my{parent}) & \
                                   (asset == my{asset.filename})}.exists?
    errors.add(:asset, 'has already been associated with this resource')
    false
  end

end
