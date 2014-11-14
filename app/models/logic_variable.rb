class LogicVariable < ActiveRecord::Base

  RESERVED_WORDS = %w(do if in for let new try var case else enum eval 
                         false null this true void with break catch class 
                         const super throw while yield delete export 
                         import public return static switch typeof 
                         default extends finally package private continue 
                         debugger function arguments interface protected 
                         implements instanceof seedrandom)

  RESERVED_WORDS_REGEX = Regexp.compile("^[#{RESERVED_WORDS.join('|')}]$")
                               
  VARIABLE_REGEX = /^[_a-zA-Z]{1}\w*$/

  belongs_to :logic

  has_many :logic_variable_values, dependent: :destroy

  validate :variables_well_formatted

  protected

  def variables_well_formatted
      if !variables.all?{|var| VARIABLE_REGEX =~ var}
        errors.add(:variables, "can only contain letter, numbers and 
                                underscores.  Additionally, the first character 
                                must be a letter or an underscore.")
      end

      reserved_variables = variables.collect do |v| 
        match = RESERVED_WORDS_REGEX.match(v)
        match.nil? ? nil : match[0]
      end
      reserved_variables.compact!
      
      reserved_variables.each do |v|
        errors.add(:variables, "cannot contain the reserved word '#{v}'.")
      end

      return errors.none?
  end
end
