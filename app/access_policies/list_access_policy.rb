class ListAccessPolicy
  # Contains all the rules for which requestors can do what with which List objects.

  def self.action_allowed?(action, requestor, list)
    case action
    when :index
      true
    when :read
      list.has_read_permission?(requestor) ||
      list.is_published?
    when :create
      list.has_write_permission?(requestor) &&
      !list.is_persisted?
    when :update, :destroy
      list.has_write_permission?(requestor)
    else
      false
    end
  end

end
