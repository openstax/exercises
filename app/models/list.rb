class List < ActiveRecord::Base
  attr_accessible :name, :is_public, :list_exercises_attributes

  accepts_nested_attributes_for :list_exercises, :allow_destroy => true

  belongs_to :parent_list, :class_name => 'List'

  belongs_to :reader_user_group, :class_name => 'UserGroup', :dependent => :destroy
  belongs_to :editor_user_group, :class_name => 'UserGroup', :dependent => :destroy
  belongs_to :publisher_user_group, :class_name => 'UserGroup', :dependent => :destroy
  belongs_to :manager_user_group, :class_name => 'UserGroup', :dependent => :destroy

  has_many :list_exercises, :dependent => :destroy
  has_many :exercises, :through => :list_exercises

  validates_presence_of :name, :reader_user_group, :editor_user_group, :publisher_user_group, :manager_user_group
  validates_uniqueness_of :name, :if => :is_public

  before_validation :create_user_groups, :on => :create
  after_create :set_user_groups_container

  protected

  def create_user_groups
    self.reader_user_group = UserGroup.create(:name => 'readers')
    self.reader_user_group_id = reader_user_group.id
    self.editor_user_group = UserGroup.create(:name => 'editors')
    self.editor_user_group_id = editor_user_group.id
    self.publisher_user_group = UserGroup.create(:name => 'publishers')
    self.publisher_user_group_id = publisher_user_group.id
    self.manager_user_group = UserGroup.create(:name => 'managers')
    self.manager_user_group_id = manager_user_group.id
  end

  def set_user_groups_container
    self.reader_user_group.container = self
    self.reader_user_group.save
    self.editor_user_group.container = self
    self.editor_user_group.save
    self.publisher_user_group.container = self
    self.publisher_user_group.save
    self.manager_user_group.container = self
    self.manager_user_group.save
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
    has_permission?(user, :manager)
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end
end
