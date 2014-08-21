# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

# Frameworks
gem 'rails', '4.1.5'
gem 'jquery-rails'
gem 'lev'

# SQL Queries
gem 'squeel'

# Utilities
gem 'openstax_utilities'

# Cron Jobs
gem 'whenever'

# Access Control
gem 'fine_print'
gem 'openstax_accounts', path: '../accounts-rails'
gem 'openstax_api'
gem 'doorkeeper'

# File Uploads
gem 'remotipart'
gem 'carrierwave'
gem 'mini_magick'

# Tags
gem 'acts-as-taggable-on'

# Derivation
gem 'deep_cloneable'

# Search
gem "keyword_search"

# Logic
gem 'ejs'
gem 'eco'

# Voting
gem 'acts_as_votable'

# Comments
gem 'commontator'

# API documentation
gem 'apipie-rails'
gem 'maruku'
gem 'representable'
gem 'roar-rails'

# Administration
gem 'exception_notification'
gem 'newrelic_rpm'

# Backup
gem 'yaml_db'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'bootstrap-sass'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier'
  gem 'compass-rails'
end

group :development, :test do
  gem 'sqlite3'
  gem 'thin'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'debugger'
  gem 'brakeman'

  gem 'quiet_assets'
  gem 'timecop'
  gem 'cheat'
  
  gem 'rails-erd'
  gem 'railroady'
  gem 'coffee-rails-source-maps'
end

group :production do
  gem 'mysql2', '~> 0.3.11'
end
