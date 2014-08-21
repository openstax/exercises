class ListEditorAccessPolicy
  # Contains all the rules for which requestors can do what with which ListEditor objects.

  def self.action_allowed?(action, requestor, list_editor)
    false
  end

end
