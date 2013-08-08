class Attachment < ActiveRecord::Base
  mount_uploader :asset, AssetUploader

  belongs_to :attachable, :polymorphic => true

  attr_accessible :asset, :caption, :alt, :local_name

  before_validation :assign_next_number, :on => :create
  after_destroy :destroy_callback

  validates_presence_of :number, :attachable, :asset, :local_name, :caption, :alt
  validates_uniqueness_of :number, :scope => [:attachable_type]
  validates_uniqueness_of :local_name, :scope => [:attachable_type, :attachable_id]

  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    attachable.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    attachable.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    can_be_created_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_created_by?(user)
  end

  protected

  #############
  # Callbacks #
  #############

  def assign_next_number
    self.number = ((where(:attachable_type => attachable_type).maximum(:number) || -1) + 1) if number.nil?
  end

  def destroy_callback
    remove_asset! if find_by_number(number).nil?
  end
end
