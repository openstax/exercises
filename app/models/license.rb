class License < ActiveRecord::Base
  sortable

  has_many :exercises, :inverse_of => :license
  has_many :solutions, :inverse_of => :license

  attr_accessible :name, :short_name, :url, :partial_filename

  validates_presence_of :name, :short_name, :url, :partial_filename

  def self.options
    all.collect{|l| [l.short_name, l.id]}
  end

  ##################
  # Access Control #
  ##################
    
  def can_be_created_by?(user)
    !user.nil? && user.is_admin?
  end
  
  def can_be_updated_by?(user)
    exercises.empty? && solutions.empty? && can_be_created_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end
end
