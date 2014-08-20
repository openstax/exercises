#TODO: Before publishing an exercise with logic, verify that the variables match the logic outputs and cover all of the variables in the exercise content.

class Logic < ActiveRecord::Base
  has_many :logic_outputs, dependent: :destroy

  after_initialize :initialize_library_version_ids

  serialize :variables
  serialize :library_version_ids

  validate :variables_well_formatted
  validate :library_version_ids_well_formatted

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

  def variables_well_formatted
      if !variables.all?{|var| VARIABLE_REGEX =~ var}
        errors.add(:variables, "can only contain letter, numbers and 
                                underscores.  Additionally, the first character 
                                must be a letter or an underscore.")
      end

      reserved_variables = variables.collect do |v| 
        match = JS_RESERVED_WORDS_REGEX.match(v) || OTHER_RESERVED_WORDS_REGEX.match(v)
        match.nil? ? nil : match[0]
      end
      reserved_variables.compact!
      
      reserved_variables.each do |v|
        errors.add(:variables, "cannot contain the reserved word '#{v}'.")
      end

      return errors.none?
  end

  def library_version_ids_well_formatted
      errors.add(:library_version_ids, "aren't an array") and return true if !library_version_ids.is_a?(Array) 
      errors.add(:library_version_ids, "include non integers") and return true if library_version_ids.any?{|id| !id.is_a?(Integer)}
      return errors.none?
  end

  # Put the required libraries in
  def initialize_library_version_ids
    self.library_version_ids ||= Library.latest_prerequisite_versions(false).collect{|v| v.id}
  end

end
