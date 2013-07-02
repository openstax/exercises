class Attachments < ActiveRecord::Base
  attr_accessible :asset, :caption, :alt, :local_name

  belongs_to :attachable, :polymorphic => true

  validates_presence_of :asset, :local_name
  validates_uniqueness_of :local_name, :scope => [:attachable_type, :attachable_id]

  after_destroy :destroy_callback

  mount_uploader :asset, AssetUploader

  protected

  def destroy_callback
    remove_asset! if find_by_number(number).nil?
  end

  public

  ##########################
  # Access control methods #
  ##########################
end
