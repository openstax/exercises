class BookAccessPolicy
  # Contains all the rules for which requestors can do what with which OpenStax::Content::Books

  def self.action_allowed?(action, requestor, book)
    case action
    when :index, :read
      !requestor.is_anonymous? && requestor.is_human?
    else
      false
    end
  end
end
