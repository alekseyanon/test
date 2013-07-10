#!/usr/bin/env rake
# fun coding: UTF-8
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

if defined?(RSpec)
  task default: :spec
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new :spec
end

require File.expand_path('../config/application', __FILE__)
Smorodina::Application.load_tasks
