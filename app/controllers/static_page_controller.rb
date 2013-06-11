# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StaticPageController < ApplicationController

  layout :resolve_layout

protected

  def resolve_layout
    'home' == action_name ? 'application_home_page' : 'application_body_only'
  end

end