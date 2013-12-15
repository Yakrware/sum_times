SSHKit.config.command_map[:apt_install] = "/usr/bin/env sudo apt-get install -y"

namespace :deploy do
  desc "Setup server by installing required libraries and other initialization tasks"
  task :setup do
    on roles(:app) do
      execute :apt_install, "libpq-dev"
    end
  end
end
