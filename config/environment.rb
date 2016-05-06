# Load the rails application
require File.expand_path('../application', __FILE__)

require 'user_mapper'

require 'style'
require 'solution_type'
require 'language'

require 'has_attachments'
require 'has_logic'
require 'has_tags'

require 'publishable'
require 'solution'
require 'stylable'
require 'user_html'

require 'active_record/calculations_patch'

require 'row_parser'
require 'import/xlsx_importer'
require 'import/publishable_importer'
require 'import/exercise_importer'
require 'import/vocab_term_importer'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
