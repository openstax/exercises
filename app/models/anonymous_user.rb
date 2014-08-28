class AnonymousUser

  include Singleton

  def is_human?
    true
  end
  
  def is_application?
    false
  end

  def is_anonymous?
    true
  end

end
