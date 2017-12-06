# Load the rails application
require File.expand_path('../application', __FILE__)

require 'user_mapper'

require 'style'
require 'solution_type'
require 'language'

require 'has_attachments'
require 'has_logic'
require 'has_tags'

require 'row_parser'
require 'xlsx'

require 'publishable'
require 'exercises'
require 'vocab_terms'

require 'solution'
require 'stylable'
require 'user_html'

require 'ar_collection_setter'

require 'active_record/calculations_patch'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
