class List < ActiveRecord::Base
  attr_accessible :name, :is_public, :list_questions_attributes, :reader_user_group_id, :editor_user_group_id, :publisher_user_group_id, :manager_user_group_id

  has_many :list_questions, :dependent => :destroy
  has_many :questions, :through => :list_questions

  has_one :reader_user_group, :class_name => 'UserGroup', :dependent => :destroy
  has_one :editor_user_group, :class_name => 'UserGroup', :dependent => :destroy
  has_one :publisher_user_group, :class_name => 'UserGroup', :dependent => :destroy
  has_one :manager_user_group, :class_name => 'UserGroup', :dependent => :destroy

  has_many :readers, :class_name => 'User', :through => :reader_user_group
  has_many :editors, :class_name => 'User', :through => :editor_user_group
  has_many :publishers, :class_name => 'User', :through => :publisher_user_group
  has_many :managers, :class_name => 'User', :through => :manager_user_group

  accepts_nested_attributes_for :list_questions, :allow_destroy => true

  validates_presence_of :name

  after_create :create_user_groups  

  protected

  def create_user_groups
    self.reader_user_group = UserGroup.new
    self.reader_user_group.externally_managed = true
    self.reader_user_group.save
    self.editor_user_group = UserGroup.new
    self.editor_user_group.externally_managed = true
    self.editor_user_group.save
    self.publisher_user_group = UserGroup.new
    self.publisher_user_group.externally_managed = true
    self.publisher_user_group.save
    self.manager_user_group = UserGroup.new
    self.manager_user_group.externally_managed = true
    self.manager_user_group.save
    self.save
  end

  def permission_group_for(permission)
    case permission.to_s.downcase
    when 'reader'
      reader_user_group
    when 'editor'
      editor_user_group
    when 'publisher'
      publisher_user_group
    when 'manager'
      manager_user_group
    else
      nil
    end
  end

  public
  
  def add_exercise(exercise)
    ListExercise.create(:list => self, :exercise => exercise)
  end

  def add_permission(user, permission)
    return false if user.nil?
    pg = permission_group_for(permission)
    return false if pg.nil?
    pg.add_member(user)
  end

  def remove_permission(user, permission)
    return false if user.nil?
    pg = permission_group_for(permission)
    return false if pg.nil?
    pg.remove_member(user)
  end

  def has_permission?(user, permission)
    return false if user.nil?
    pg = permission_group_for(permission)
    return false if pg.nil?
    pg.is_member?(user)
  end
  
  ##########################
  # Access control methods #
  ##########################

  def can_be_read_by?(user)
    is_public || has_permission?(user, :reader) || has_permission?(user, :editor) || \
    has_permission?(user, :publisher) || has_permission?(user, :manager)
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
