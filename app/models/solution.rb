class Solution < ActiveRecord::Base
  attachable
  content
  publishable :question_id

  add_prepublish_check(:has_blank_content?, false, 'The contents of this solution are blank.')

  belongs_to :question, :inverse_of => :solutions
  has_one :exercise, :through => :question

  attr_accessible :summary

  validates_presence_of :question
  validates_presence_of :summary

  def to_param
    if is_published?
      "s#{number}v#{version}"
    else
      "s#{id}d"
    end
  end

  def name
    to_param
  end

  def has_blank_content?
    content.blank?
  end

  def self.from_param(exercise, param)
    escope = where(:exercise_id => exercise.id)
    if (param =~ /^s(\d+)d$/)
      s = escope.not_published.where(:id => $1.to_i)
    elsif (param =~ /^s(\d+)(v(\d+))?$/)
      s = escope.published.where(:number => $1.to_i)
      if $2.nil?
        s = s.latest
      else
        s = s.where(:version => $3.to_i)
      end
    elsif (param =~ /^(\d+)$/)
      s = where(:id => $1.to_i)
    else
      raise SecurityTransgression
    end
    
    s = s.first
    raise ActiveRecord::RecordNotFound if s.nil?
    s
  end

  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    exercise.can_be_read_by?(user) && (is_published? || has_collaborator?(user))
  end
    
  def can_be_created_by?(user)
    exercise.can_be_read_by?(user) && !is_published?
  end
  
  def can_be_updated_by?(user)
    can_be_created_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_created_by?(user)
  end
end
