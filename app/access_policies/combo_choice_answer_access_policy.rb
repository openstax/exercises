class ComboChoiceAnswerAccessPolicy
  # Contains all the rules for which requestors can do what with which ComboChoiceAnswer objects.

  def self.action_allowed?(action, requestor, combo_choice_answer)
    false
  end

end
