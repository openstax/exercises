# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module ApplicationAccountBarHelper
  def salutation(user)
    return "Welcome, #{user.first_name || user.username}" if user
  end

  def account_bar_transparent
    content_for :account_bar_class do
      "transparent "
    end
  end
end
