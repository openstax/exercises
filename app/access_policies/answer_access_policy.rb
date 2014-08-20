class AnswerAccessPolicy
  # Contains all the rules for which requestors can do what with which Answer objects.

  def self.action_allowed?(action, requestor, answer)
    false
  end

end
