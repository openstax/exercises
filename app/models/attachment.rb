class Attachment < ActiveRecord::Base
  mount_uploader :asset, AssetUploader
  skip_callback :commit, :after, :remove_asset!

  belongs_to :attachable, :polymorphic => true

  attr_accessible :asset_cache, :local_name, :caption, :alt

  before_validation :assign_next_number, :on => :create
  after_save :update_cached_content
  after_destroy :destroy_callback

  validates_presence_of :number, :attachable, :asset, :local_name
  validates_uniqueness_of :number, :scope => [:attachable_type, :attachable_id]
  validates_uniqueness_of :local_name, :scope => [:attachable_type, :attachable_id]

  ##################
  # Access Control #
  ##################
  
  def can_be_updated_by?(user)
    attachable.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end

  protected

  #############
  # Callbacks #
  #############

  def assign_next_number
    self.number ||= (Attachment.where(:attachable_type => attachable_type).maximum(:number) || -1) + 1
  end

  def update_cached_content
    return unless attachable.respond_to? :parse_and_cache_content
    attachable.parse_and_cache_content(true)
    attachable.save!
  end

  def destroy_callback
    remove_asset! if Attachment.find_by_number(number).nil?
    update_cached_content
  end
end
