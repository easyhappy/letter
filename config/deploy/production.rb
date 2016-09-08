server '120.76.242.234', user: 'deployer', roles: %w{web app db}
set :branch, 'master'

set :unicorn_env, "production"
set :unicorn_rack_env, "production"
set :rails_env, "production"
set :rbenv_ruby, '2.3.1'
set :environment, 'production'