class Logic < ActiveRecord::Base
  has_many :logic_outputs, dependent: :destroy

  after_initialize :initialize_library_version_ids

  before_validation :cleanup_library_version_ids

  validate :can_parse_variables
  validate :can_parse_library_version_ids

  after_update :clear_old_outputs

  JS_RESERVED_WORDS = %w(do if in for let new try var case else enum eval 
                         false null this true void with break catch class 
                         const super throw while yield delete export 
                         import public return static switch typeof 
                         default extends finally package private continue 
                         debugger function arguments interface protected 
                         implements instanceof)

  JS_RESERVED_WORDS_REGEX = Regexp.compile("^(#{JS_RESERVED_WORDS.join('|')})$")
               
  OTHER_RESERVED_WORDS = %w(seedrandom)

  OTHER_RESERVED_WORDS_REGEX = Regexp.compile("^(#{OTHER_RESERVED_WORDS.join('|')})$")
                               
  VARIABLE_REGEX = /^[_a-zA-Z]{1}\w*$/

  delegate_access_control to: :logicable

  # Instead of using polymorphic belongs_to, we explicitly search the available parents
  def logicable
    (Exercise.where(logic_id: id) || Solution.where(logic_id: id)).first
  end

  def clear_old_outputs
    logic_outputs.where{updated_at.lt my{updated_at}}.destroy_all
  end

protected

  def can_parse_variables
    begin
      vars = JSON.parse(variables)

      if !vars.all?{|var| VARIABLE_REGEX =~ var}
        errors.add(:variables, "can only contain letter, numbers and 
                                underscores.  Additionally, the first character 
                                must be a letter or an underscore.")
      end

      reserved_vars = vars.collect do |v| 
        match = JS_RESERVED_WORDS_REGEX.match(v) || OTHER_RESERVED_WORDS_REGEX.match(v)
        match.nil? ? nil : match[0]
      end
      reserved_vars.compact!
      
      reserved_vars.each do |v|
        errors.add(:variables, "cannot contain the reserved word '#{v}'.")
      end

      return errors.none?
    rescue Exception => e
      errors.add(:variables, e.message) and return false
    end
  end

  def can_parse_library_version_ids
    begin
      ids = JSON.parse(library_version_ids)

      errors.add(:library_version_ids, "aren't an array") and return true if !ids.is_a?(Array) 
      errors.add(:library_version_ids, "include non integers") and return true if ids.any?{|id| !id.is_a?(Integer)}

      return true
    rescue Exception => e
      errors.add(:library_version_ids, e.message) and return false
    end
  end

  # Put the required librarys in
  def initialize_library_version_ids
    self.library_version_ids ||= JSON.generate(Library.latest_prerequisite_versions(false).collect{|v| v.id})
  end

end
