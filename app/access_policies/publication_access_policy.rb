class PublicationAccessPolicy
  # Contains all the rules for which requestors can do what with which Publications

  def self.action_allowed?(action, requestor, publication)
    case action
    when :publish
      !publication.is_published? && publication.has_write_permission?(requestor)
    else
      false
    end
  end

end
