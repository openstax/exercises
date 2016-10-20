class PublicationAccessPolicy
  # Contains all the rules for which requestors can do what with which Publication objects.

  def self.action_allowed?(action, requestor, publication)
    case action
    when :read, :publish
      !publication.is_published? &&
      publication.has_write_permission?(requestor)
    else
      false
    end
  end

end
