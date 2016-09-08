# config valid only for Capistrano 3.1
lock '3.5.0'
set :application, 'letter'

set :repo_url, "git@github.com:easyhappy/letter.git"

set :deploy_to, '/home/deployer/apps/letter'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :bundle_binstubs, nil

set :pty, true

set :linked_files, %w{config/database.yml config/secrets.yml  config/redis.yml config/cable.yml}

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH"}

set :ssh_options, {:forward_agent => true}

set :keep_releases, 5


namespace :deploy do
  after :publishing, 'unicorn:restart'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      with rails_env: fetch(:rails_env) do
        within release_path do
          execute :'bin/rake', 'tmp:clear'
        end
      end
    end
  end
end
