set :application, 'sumtimes'

set :scm, :git
set :repo_url, 'git://github.com/Yakrware/sum_times.git'

set :deploy_to, "/home/ubuntu/#{fetch(:application)}"

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rvm1_ruby_version, '2.0.0-p353'
#before 'deploy', 'rvm1:install:rvm'  # install/update RVM
#before 'deploy', 'rvm1:install:ruby'  # install/update Ruby

namespace :deploy do  
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  
  namespace :check do
    task :linked_files => shared_path.join('config/application.yml')
  end
  
  after :finishing, 'deploy:cleanup'

end

remote_file shared_path.join('config/application.yml') => 'config/application.yml', roles: :app

file 'config/application.yml' do |t|
  on roles(:app) do |host|
    upload! t.name, shared_path.join(t.name)
  end
end
