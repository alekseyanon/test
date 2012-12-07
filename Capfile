load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks'
load 'deploy/assets'
require "bundler/capistrano"
