# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module ApplicationFooterHelper

  def copyright_text
    year_range = "2011-#{Time.now.year}".sub(/\A(\d+)-\1\z/, '\1');
    "Copyright &copy; #{year_range} #{COPYRIGHT_HOLDER}".html_safe
  end

end