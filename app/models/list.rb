class List < ActiveRecord::Base
  attr_accessible :name, :is_public, :list_questions_attributes, :reader_user_group_id, :editor_user_group_id, :publisher_user_group_id, :manager_user_group_id

  has_many :list_questions, :dependent => :destroy
  has_many :questions, :through => :list_questions

  has_one :reader_user_group, :class_name => 'UserGroup'
  has_one :editor_user_group, :class_name => 'UserGroup'
  has_one :manager_user_group, :class_name => 'UserGroup'
  has_one :publisher_user_group, :class_name => 'UserGroup'

  accepts_nested_attributes_for :list_questions, :allow_destroy => true

  validates_presence_of :name, :reader_user_group, :editor_user_group, :publisher_user_group, :manager_user_group
  validates_uniqueness_of :name
  
  def add_question!(question)
    ListQuestion.create(:list => self, :question => question)
  end

  def is_reader?(user)
    return false if user.nil?
    reader_user_group.is_member?(user) || \
    editor_user_group.is_member?(user) || \
    publisher_user_group.is_member?(user) || \
    manager_user_group.is_member?(user) ||
  end

  def is_manager?(user)
    return false if user.nil?
    manager_user_group.is_member?(user)
  end
  
  ##########################
  # Access control methods #
  ##########################

  def can_be_read_by?(user)
    is_public || is_reader?(user)
  end
    
  def can_be_created_by?(user)
    !user.nil?
  end
  
  def can_be_updated_by?(user)
    is_manager?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end
end
