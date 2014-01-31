class LibraryVersion < ActiveRecord::Base
  belongs_to :library

  before_validation :assign_version, :on => :create

  before_update :not_used
  before_update :verify_latest
  before_destroy :not_used
  before_destroy :verify_latest

  attr_accessible :code, :deprecated

  delegate_access_control to: :library

  scope :ordered, order{version.asc}

  def name
    library.name + " v." + version.to_s
  end
  
  def logics_using
    Logic.where{required_library_version_ids =~ "%'#{id}'%"}
  end
  
  def v_dot
    "v.#{version}"
  end


protected
  
  def assign_version
    self.version = LibraryVersion.where{library_id == my{library.id}}.count + 1
  end
  
  def not_used
    # check that there are no logics using this version
    errors.add(:base, "This version cannot be changed or deleted because it is used by a question") if
      logics_using.any?
    errors.none?
  end
  
  def verify_latest
    errors.add(:base, "Non-latest versions cannot be changed or destroyed") if
      logic_library.latest_version != self
    errors.none?
  end
end
