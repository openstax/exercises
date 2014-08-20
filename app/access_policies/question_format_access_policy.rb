class QuestionFormatAccessPolicy
  # Contains all the rules for which requestors can do what with which QuestionFormat objects.

  def self.action_allowed?(action, requestor, question_format)
    false
  end

end
