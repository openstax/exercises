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

  # GET /about
  def about
  end

  # GET /contact
  def contact
  end

  # GET /copyright
  def copyright
  end

  # GET /developers
  def developers
  end

  # GET /help
  def help
  end

  # GET /share
  def share
  end

  # GET /status
  # Used by AWS (and others) to make sure the site is still up
  def status
    head :ok
  end

  # GET /tou
  def tou
  end

  protected

  def resolve_layout
    'home' == action_name ? 'application_home_page' : 'application_body_only'
  end

end
