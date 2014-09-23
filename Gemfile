# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

# Rails
gem 'rails', '4.1.5'

# Use jQuery as the JavaScript library
gem 'jquery-rails'

# Use jQuery UI as the JavaScript UI library
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Lev Framework
gem 'lev'

# SQL Queries
gem 'squeel'

# Utilities
gem 'openstax_utilities'

# Cron Jobs
gem 'whenever'

# Access Control
gem 'fine_print'
gem 'openstax_accounts'
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

# New Relic
gem 'newrelic_rpm'

# Backup
gem 'yaml_db'

# Assets
# Use SCSS for stylesheets
gem 'bootstrap-sass'
gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
# Automatically add vendor CSS prefixes
gem 'autoprefixer-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Use debugger
  gem 'debugger'

  gem 'thin'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'brakeman'

  gem 'quiet_assets'
  gem 'timecop'
  gem 'cheat'
  
  gem 'rails-erd'
  gem 'railroady'
  gem 'coffee-rails-source-maps'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use Capistrano for deployment
  # gem 'capistrano-rails'
end

group :production do
  gem 'pg'

  # Use unicorn as the app server
  # gem 'unicorn'

  gem 'exception_notification'
end
