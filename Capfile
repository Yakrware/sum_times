# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails/tree/master/assets
#   https://github.com/capistrano/rails/tree/master/migrations
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'rvm1/capistrano3'
require "whenever/capistrano"
require "capistrano3/unicorn"

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

namespace :deploy do
  task :setup do
    on roles(:all) do |host|
    end
  end
  
  after :setup, :deploy_directory do
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      info "#{fetch(:deploy_to)} is not writable on #{host}, creating"
      # create directory
      sh "mkdir -pv #{fetch(:deploy_to)}/shared/config"
    end
  end
    
  after :setup, :copy_shared_files do
    fetch(:linked_files).each do |f|
      if test("[ -f #{fetch(:deploy_to)}/shared/config/#{f}]")
      else
        upload!("config/#{f}", "#{fetch(:deploy_to)}/shared/config/#{f}]")
      end
    end
  end
    
end
