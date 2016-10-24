class ListAccessPolicy
  # Contains all the rules for which requestors can do what with which Lists

  def self.action_allowed?(action, requestor, list)
    case action
    when :search
      true
    when :create
      !requestor.is_anonymous? && requestor.is_human?
    when :read
      list.is_public? || list.has_read_permission?(requestor)
    when :update, :destroy
      !list.is_published? && list.has_write_permission?(requestor)
    when :new_version
      list.is_published? && list.has_write_permission?(requestor)
    else
      false
    end
  end

end
