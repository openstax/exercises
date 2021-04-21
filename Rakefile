#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

ENV['RAILS_ENV'] = 'test' if ARGV[0] == 'parallel:spec'

require File.expand_path('../config/application', __FILE__)

Exercises::Application.load_tasks
