class List < ActiveRecord::Base
  belongs_to :parent_list, :class_name => 'List', :inverse_of => :child_lists
  has_many :child_lists, :class_name => 'List', :foreign_key => :parent_list_id,
           :dependent => :destroy, :inverse_of => :parent_list

  has_many :list_exercises, :dependent => :destroy, :inverse_of => :list
  has_many :exercises, :through => :list_exercises
  has_many :solutions, :through => :exercises

  has_many :user_groups, :as => 'container', :dependent => :destroy
  has_many :users, :through => :user_groups

  belongs_to :reader_user_group, :class_name => 'UserGroup'
  has_many :readers, :through => :reader_user_group, :source => :users

  belongs_to :editor_user_group, :class_name => 'UserGroup'
  has_many :editors, :through => :editor_user_group, :source => :users

  belongs_to :publisher_user_group, :class_name => 'UserGroup'
  has_many :publishers, :through => :publisher_user_group, :source => :users

  belongs_to :owner_user_group, :class_name => 'UserGroup'
  has_many :owners, :through => :owner_user_group, :source => :users

  accepts_nested_attributes_for :list_exercises, :allow_destroy => true

  attr_accessible :name, :is_public, :list_exercises_attributes

  before_validation :create_user_groups, :on => :create
  after_create :set_user_groups_container

  validates_presence_of :name, :reader_user_group, :editor_user_group, :publisher_user_group, :owner_user_group
  validates_uniqueness_of :name, :if => :is_public

  def has_exercise?(exercise)
    !list_exercises.where(:exercise_id => exercise.id).first.nil?
  end

  def add_exercise(exercise)
    ListExercise.create(:list => self, :exercise => exercise)
  end

  def has_permission?(user, permission)
    pg = permission_group_for(permission)
    return false if pg.nil?
    pg.has_user?(user)
  end

  def add_permission(user, permission)
    pg = permission_group_for(permission)
    return false if pg.nil?
    pg.add_user(user)
  end

  def user_group_checks
    return if !owners.first.nil?

    new_owner = publishers.first || editors.first || readers.first
    return destroy if new_owner.nil?

    add_permission(new_owner, :owner)
  end

  ##################
  # Access Control #
  ##################

  def can_be_created_by?(user)
    !user.nil?
  end

  def can_be_read_by?(user)
    is_public || has_permission?(user, :reader) || \
    has_permission?(user, :editor) || \
    has_permission?(user, :publisher) || \
    has_permission?(user, :owner)
  end
  
  def can_be_edited_by?(user)
    has_permission?(user, :editor) || \
    has_permission?(user, :publisher) || \
    has_permission?(user, :owner)
  end

  def can_be_published_by?(user)
    has_permission?(user, :publisher) || \
    has_permission?(user, :owner)
  end

  def can_be_updated_by?(user)
    has_permission?(user, :owner)
  end

  protected

  def permission_group_for(permission)
    case permission.to_s.downcase
    when 'reader'
      reader_user_group
    when 'editor'
      editor_user_group
    when 'publisher'
      publisher_user_group
    when 'owner'
      owner_user_group
    else
      nil
    end
  end

  #############
  # Callbacks #
  #############

  def create_user_groups
    self.reader_user_group = UserGroup.create!(:name => 'Readers')
    self.reader_user_group_id = reader_user_group.id
    self.editor_user_group = UserGroup.create!(:name => 'Editors')
    self.editor_user_group_id = editor_user_group.id
    self.publisher_user_group = UserGroup.create!(:name => 'Publishers')
    self.publisher_user_group_id = publisher_user_group.id
    self.owner_user_group = UserGroup.create!(:name => 'Owners')
    self.owner_user_group_id = owner_user_group.id
  end

  def set_user_groups_container
    self.reader_user_group.container = self
    self.reader_user_group.save!
    self.editor_user_group.container = self
    self.editor_user_group.save!
    self.publisher_user_group.container = self
    self.publisher_user_group.save!
    self.owner_user_group.container = self
    self.owner_user_group.save!
  end
end
