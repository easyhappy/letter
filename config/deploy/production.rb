# Production Stage
set :stage, :production
set :branch, 'master'
set :rails_env, :production
role :resque_worker, ["139.224.45.206"]
role :resque_scheduler, "139.224.45.206"

server '139.224.45.206', user: 'deployer', roles: %w(db app web), primary: true, ssh_options:{
  forward_agent: true
}

# server '192.168.100.11', user: 'deploy', roles: %w(app), primary: true, ssh_options:{
#   forward_agent: true
# }

namespace :deploy do

  desc '切记这个task 只在内侧 时候使用, 发布时需要删除该task!!!!'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end

    on roles(:db), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
      #invoke 'unicorn:restart'
      #invoke 'resque:stop'

      within release_path do
        #execute :rake, 'environment websocket_rails:stop_server'
        #execute  :sudo, "/etc/init.d/postgresql restart"
      end
      #invoke 'rails:rake:db:drop'
      #invoke 'postgresql:create_database'
      #invoke 'rails:rake:db:migrate'
      #invoke 'rails:rake:db:seed'
      #invoke 'resque:start'
      # within "/home/deploy/express_data" do
      #   #execute :sh, "/home/deploy/express_data/import.sh"
      # end
      within release_path do
        #execute :rake, 'environment websocket_rails:start_server'
      end
    end

    # on roles(:app), in: :sequence, wait: 5 do
    #   execute :touch, release_path.join('tmp/restart.txt')
    #   invoke 'unicorn:start'
    #   invoke 'resque:restart'
    # end
  end

  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
