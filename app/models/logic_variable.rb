class LogicVariable < ActiveRecord::Base

  JS_RESERVED_WORDS = %w(do if in for let new try var case else enum eval 
                         false null this true void with break catch class 
                         const super throw while yield delete export 
                         import public return static switch typeof 
                         default extends finally package private continue 
                         debugger function arguments interface protected 
                         implements instanceof seedrandom)

  JS_RESERVED_WORDS_REGEX = Regexp.compile("^[#{JS_RESERVED_WORDS.join('|')}]$")
                               
  VARIABLE_REGEX = /^[_a-zA-Z]{1}\w*$/

  sortable :logic

  belongs_to :logic, inverse_of: :logic_variables

  has_many :logic_variable_values, dependent: :destroy, inverse_of: :logic_variable

  validate :variables_well_formatted

  delegate_access_control to: :logic

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
end
