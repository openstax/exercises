class License < ActiveRecord::Base
  sortable

  has_many :exercises, :inverse_of => :license
  has_many :solutions, :inverse_of => :license

  attr_accessible :name, :short_name, :url, :publishing_contract_name, :allow_exercises, :allow_solutions

  validates_presence_of :name, :short_name, :url, :publishing_contract_name

  scope :for_exercises, where(:allow_exercises => true)
  scope :for_solutions, where(:allow_solutions => true)

  def valid_for?(publishable)
    case publishable.class.name
    when 'Exercise'
      allow_exercises
    when 'Solution'
      allow_solutions
    else
      false
    end
  end

  def self.options_for(publishable)
    case publishable.class.name
    when 'Exercise'
      pscope = for_exercises
    when 'Solution'
      pscope = for_solutions
    else
      pscope = none
    end
    pscope.all.collect{|l| [l.short_name, l.id]}
  end

  ##################
  # Access Control #
  ##################
    
  def can_be_created_by?(user)
    !user.nil? && user.is_admin?
  end
  
  def can_be_updated_by?(user)
    can_be_created_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    exercises.empty? && solutions.empty? && can_be_updated_by?(user)
  end
end
