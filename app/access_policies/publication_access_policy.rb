class PublicationAccessPolicy
  # Contains all the rules for which requestors can do what with which Publication objects.

  def self.action_allowed?(action, requestor, publication)
    case action
    when :read, :publish
      publication.editors.include?(requestor) || \
        publication.authors.include?(requestor) || \
        publication.copyright_holders.include?(requestor)
    else
      false
    end
  end

end
