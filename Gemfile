# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

gem 'rails', '3.2.17'

gem 'jquery-rails', '2.3.0'
gem 'squeel'

gem 'lev', "~> 2.1.1"

gem 'whenever', :require => false
gem 'newrelic_rpm'
gem 'yaml_db'

gem 'nested_form'

gem 'carrierwave'
gem 'mini_magick'
gem 'parslet', '~> 1.5'

gem 'acts-as-taggable-on'
gem 'acts_as_votable'
gem 'deep_cloneable'
gem 'remotipart', '~> 1.2'

gem 'commontator', '~> 4.6.1'
gem 'fine_print', '~> 1.4.1'
gem 'openstax_accounts', '~> 2.0.0'
gem 'openstax_utilities', '~> 3.0.0'
gem 'openstax_api', '~> 2.2.3'

# API documentation
gem 'apipie-rails', '~> 0.1.2'
gem 'maruku'
gem 'representable', '~> 1.8.2'
gem 'roar-rails'

gem 'doorkeeper', '~> 0.6.7'
gem 'exception_notification'

gem "keyword_search", "~> 1.5.0"

gem 'ejs'
gem 'eco'

gem 'tinymce-rails', git: 'git://github.com/spohlenz/tinymce-rails.git', branch: 'tinymce-4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',     '~> 3.2.6'
  gem 'coffee-rails',   '~> 3.2.1'
  gem 'bootstrap-sass', '~> 3.1.1'
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
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'faker'
  gem 'thin'
  gem 'cheat'
  gem 'brakeman'
  gem 'railroady'
  gem 'rspec-rerun'
  gem 'cucumber-rails', :require => false
  gem 'nifty-generators'
  gem 'rack-test', require: "rack/test"
  gem 'factory_girl_rails'
  gem 'coffee-rails-source-maps'
end

group :production do
  gem 'mysql2', '~> 0.3.11'
end
