class Library < ActiveRecord::Base
  has_many :library_versions, dependent: :destroy

  before_destroy :no_versions

  attr_accessible :is_prerequisite, :language, :name, :summary

  JAVASCRIPT = 0
  LATEX = 1

  scope :prerequisites, where{is_prerequisite == true}
  scope :javascript, where{language == JAVASCRIPT}
  scope :latex, where{language == LATEX}
  
  def latest_version(include_deprecated = true)
    (include_deprecated ?
      library_versions :
      library_versions.where{deprecated == false})
    .order{version.desc}.first
  end
  
  def self.latest_versions(include_deprecated = true)
    LogicLibrary.all.collect{|library| library.latest_version(include_deprecated)}.compact
  end
  
  def self.latest_prerequisite_versions(include_deprecated = true)
    prerequisites.all.collect{|library| library.latest_version(include_deprecated)}.compact
  end

protected
  
  def no_versions
    errors.add(:base, "This library cannot be destroyed because it has versions") \
      if !library_versions.empty?

    errors.none?
  end


end
