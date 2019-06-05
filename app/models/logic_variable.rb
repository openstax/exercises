class LogicVariable < ApplicationRecord

  VARIABLE_REGEX = /\A[_a-zA-Z]{1}\w*\z/

  RESERVED_WORDS = %w(do if in for let new try var case else enum eval 
                      false null this true void with break catch class 
                      const super throw while yield delete export 
                      import public return static switch typeof 
                      default extends finally package private continue 
                      debugger function arguments interface protected 
                      implements instanceof seedrandom)

  belongs_to :logic

  has_many :logic_variable_values, dependent: :destroy

  validates :variable, presence: true, uniqueness: { scope: :logic_id },
                       format: { with: VARIABLE_REGEX },
                       exclusion: { in: RESERVED_WORDS }

end
