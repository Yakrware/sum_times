set :stages, %w(production)
set :default_stage, "production"
require 'capistrano/ext/multistage'

set :application, "sumtimes"
set :repository,  "git://github.com/Yakrware/sum_times.git"
set :scm, :git

set(:deploy_to) { "/home/ubuntu/#{application}" }

set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, 'production'
set :keep_releases, 5

set :rvm_ruby_string, '2.0.0-p195'
set :rvm_autolibs_flag, "enable"
require "rvm/capistrano"
require 'capistrano-unicorn'
require "bundler/capistrano"
load 'deploy/assets'

set :whenever_environment, defer { stage }
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

namespace :deploy do
  task :set_symlinks do
    run "ln -fs #{shared_path}/application.yml #{release_path}/config/application.yml"
    run "ln -s #{shared_path}/sockets #{release_path}/tmp/sockets"
  end

  task :setup_config, roles: :app do
    sudo "#{shared_path}/sockets"
  end
end

after "deploy:setup", "deploy:setup_config"
after 'deploy:finalize_update', 'deploy:set_symlinks'
after 'deploy:finalize_update', 'deploy:cleanup'
after 'deploy:restart', 'unicorn:restart'
