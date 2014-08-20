class ComboChoiceAccessPolicy
  # Contains all the rules for which requestors can do what with which ComboChoice objects.

  def self.action_allowed?(action, requestor, combo_choice)
    false
  end

end
