set :application, 'sumtimes'

set :scm, :git
set :repo_url, 'git://github.com/Yakrware/sum_times.git'

set :deploy_to, "/home/ubuntu/#{fetch(:application)}"

set :linked_files, %w{config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5

set :rvm1_ruby_version, '2.0.0-p353'

set :unicorn_pid, -> { File.join(shared_path, "tmp", "pids", "unicorn.pid") }

namespace :deploy do  
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
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
