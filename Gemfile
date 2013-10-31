# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'jquery-rails', '2.3.0'
gem 'thin'
gem 'squeel'

gem 'lev', "~> 2.0.4"

gem 'jbuilder'
gem 'whenever', :require => false
gem 'newrelic_rpm'
gem 'squeel'
gem 'yaml_db'
gem 'openstax_connect', '~> 0.0.6'
gem 'openstax_utilities', path: '/Users/jps/dev/openstax_utilities'  #'~> 1.0.2'
gem 'nested_form'

gem 'carrierwave'
gem 'mini_magick'
gem 'parslet', '~> 1.5'

gem 'will_paginate', '~> 3.0'
gem 'acts-as-taggable-on'
gem 'acts_as_votable'
gem 'deep_cloneable'
gem 'commontator'
gem 'fine_print', path: '/Users/jps/dev/fine_print'

# API documentation
gem 'apipie-rails'
gem 'maruku'

gem 'doorkeeper', '~> 0.6.7'
gem 'exception_notification'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',     '~> 3.2.3'
  gem 'coffee-rails',   '~> 3.2.1'
  gem 'sass-rails',     '~> 3.2.3'
  # gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'bootstrap-sass', '~> 3.0.0.0.rc'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
end

group :development, :test do
  gem 'rails-erd'
  gem 'sqlite3', '~> 1.3.6'
  gem 'debugger', '~> 1.5.0'
  gem 'quiet_assets'
  gem 'timecop'
  gem 'rspec-rails'
  gem 'capybara', '<2.1.0'  ## see: https://github.com/thoughtbot/capybara-webkit/issues/507
  gem 'capybara-screenshot'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'faker'
  gem 'thin'
  gem 'quiet_assets'
  gem 'cheat'
  gem 'brakeman'
  gem 'railroady'
  gem 'rspec-rerun'
  gem 'cucumber-rails', :require => false
  gem 'nifty-generators'
  gem 'rack-test', require: "rack/test"
  gem 'factory_girl'
end

group :production do
  gem 'mysql2', '~> 0.3.11'
end
