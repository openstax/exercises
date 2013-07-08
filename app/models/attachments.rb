class Attachments < ActiveRecord::Base
  mount_uploader :asset, AssetUploader

  attr_accessible :asset, :caption, :alt, :local_name

  belongs_to :attachable, :polymorphic => true

  after_destroy :destroy_callback

  validates_presence_of :asset, :caption, :alt, :attachable, :number, :local_name
  validates_uniqueness_of :local_name, :scope => [:attachable_type, :attachable_id]
  validates_uniqueness_of :number, :scope => [:attachable_type, :attachable_id]

  ##################
  # Access Control #
  ##################

  protected

  #############
  # Callbacks #
  #############

  def destroy_callback
    remove_asset! if find_by_number(number).nil?
  end
end
