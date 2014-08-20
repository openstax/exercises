class QuestionAccessPolicy
  # Contains all the rules for which requestors can do what with which Question objects.

  def self.action_allowed?(action, requestor, question)
    false
  end

end
