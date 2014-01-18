class Logic < ActiveRecord::Base
  # attr_accessible :code, :logicable_id, :logicable_type, :variables

  validate :can_parse_variables

  JS_RESERVED_WORDS_REGEX = /^(do|if|in|for|let|new|try|var|case|else|enum|eval|
                               false|null|this|true|void|with|break|catch|class|
                               const|super|throw|while|yield|delete|export|
                               import|public|return|static|switch|typeof|
                               default|extends|finally|package|private|continue|
                               debugger|function|arguments|interface|protected|
                               implements|instanceof)$/
                               
  OTHER_RESERVED_WORDS_REGEX = /^(seedrandom)$/
                               
  VARIABLE_REGEX = /^[_a-zA-Z]{1}\w*$/

  delegate_access_control to: :logicable

protected

  def can_parse_variables
    raise NotYetImplemeted # need to examine code below
    self.variables_array = variables.split(/[\s,]+/)
    
    if !self.variables_array.all?{|v| VARIABLE_REGEX =~ v}    
      errors.add(:variables, "can only contain letter, numbers and 
                              underscores.  Additionally, the first character 
                              must be a letter or an underscore.")
    end

    reserved_vars = self.variables_array.collect do |v| 
      match = JS_RESERVED_WORDS_REGEX.match(v) || OTHER_RESERVED_WORDS_REGEX.match(v)
      match.nil? ? nil : match[0]
    end
    
    reserved_vars.compact!
    
    reserved_vars.each do |v|
      errors.add(:variables, "cannot contain the reserved word '#{v}'.")
    end

    self.variables = self.variables_array.join(", ")

    errors.none?
  end

end
