# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StaticPagesController < ApplicationController

  layout :resolve_layout

  skip_before_filter :authenticate_user!
  fine_print_skip_signatures :general_terms_of_use, 
                             :privacy_policy

  # GET /
  def home
  end

  # GET /api
  def api
  end

  # GET /copyright
  def copyright
  end

  # GET /developers
  def developers
  end

  protected

  def resolve_layout
    'home' == action_name ? 'application_home_page' : 'application_body_only'
  end

end
