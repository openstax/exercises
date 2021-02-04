# Load the Rails application.
require_relative 'application'

require 'scout_helper'

require 'user_mapper'

require 'style'
require 'solution_type'
require 'language'

require 'has_attachments'
require 'has_logic'
require 'has_tags'

require 'row_parser'

require 'publishable'
require 'exercises'

require 'solution'
require 'stylable'
require 'user_html'

require 'ar_collection_setter'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the Rails application.
Rails.application.initialize!
