# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module ApplicationHelper

  def vertical_bar(options={})
    options = add_class(options, "vertical-bar")
    content_tag :span, nil, options
  end

  def add_class(options, klass)
    klasses = options.fetch(:class, "") + " vertical-bar "
    options[:class] = klasses;
    options
  end
end
