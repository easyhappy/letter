# config valid only for Capistrano 3.1
lock '3.5.0'

set :application, 'yuejian'
set :repo_url, 'git@git.coding.net:andyhu/letter.git'
set :deploy_to, '/home/deployer/apps/yuejian'
set :deploy_user, :deployer

set :log_level, :debug
set :scm, :git
set :format, :pretty

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system private_imgs amazing_images}

set :rvm_type, :system
set :rvm_ruby_version, '2.3.3'
set :rvm_roles, [:app, :web, :db]

set :rails_env, "production"

set :keep_releases, 10
set :pty, true
set :resque_environment_task, true


set :ssh_options, {
  :forward_agent => true,
  keys: %w(/Users/andyhu/.ssh/id_rsa_2)
}

namespace :deploy do
  # desc "Update the crontab file"
  # task :update_crontab do
  #   on roles :app do
  #     within current_path do
  #       execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)} --set environment=#{fetch(:rails_env)}"
  #     end
  #   end
  # end

  #after :publishing, :update_crontab
end
