class Attachments < ActiveRecord::Base
  attr_accessible :asset, :caption, :alt, :local_name

  belongs_to :attachable, :polymorphic => true

  after_destroy :destroy_orphaned_assets

  validates_uniqueness_of :local_name, :scope => [:attachable_type, :attachable_id]

  mount_uploader :asset, AssetUploader

  protected

  def destroy_orphaned_assets
    remove_asset! if find_by_number(number).nil?
  end
end
