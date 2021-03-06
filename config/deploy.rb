require 'bundler/capistrano'
require 'whenever/capistrano'
require 'hipchat/capistrano'

set :hipchat_token, '6d935fa6f76e7753b27886063249d0'
set :hipchat_room_name, 'Smorodina dev'
set :hipchat_announce, true

set :application, 'smorodina'
set :repository,  'git@github.com:smorodina/smorodina.git'
default_environment['PATH'] = '/usr/local/bin:/usr/bin:/bin:/opt/bin:$PATH'

role :web, '5.9.120.46'                       # Nginx
role :app, '5.9.120.46'                       # This may be the same as your `Web` server
role :db,  '5.9.120.46', primary: true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

set :scm,         :git
set :branch,      'dev'
set :deploy_to,   "/home/deployer/apps/#{application}"
#set :deploy_via,  :remote_cache
set :git_enable_submodules, 0
set :rails_env,   'production'

set :use_sudo,    false
set :user,        'deployer'

default_run_options[:pty] = true

before 'deploy:update_code',      'smorodina:daemons:stop'
before 'deploy:update_code',      'smorodina:clear_assets'
after  'deploy:update_code',      'smorodina:symlink'
#after  'smorodina:symlink',  'smorodina:db'
after  'deploy:update',           'smorodina:daemons:start'

def run_rake(task)
  run "cd #{current_path} && rake RAILS_ENV=#{rails_env} #{task}"
end


namespace :smorodina do
  desc 'Make symlink for additional smorodina files'
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml        #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/social_services.yml #{release_path}/config/social_services.yml"
    run "ln -nfs #{shared_path}/uploads                    #{release_path}/public/uploads"
    run "ln -nfs $HOME/osm/RU-LEN.osm.bz2                  #{release_path}/RU-LEN.osm.bz2"
  end

  task :clear_assets do
    run "rm -Rf #{shared_path}/assets/*"
  end

  task :db do
    run_rake 'db:rebuild_from_template'
  end

  namespace :daemons do
    desc 'Stop all application daemons'
    task :stop, roles: :app do
      unicorn.graceful_stop
    end

    desc 'Start all application daemons'
    task :start, roles: :app do
      unicorn.start
    end
  end

  set :rails_env, 'production'
  set :unicorn_config, "#{current_path}/config/unicorn.rb"
  set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

  namespace :unicorn do
    roles = {roles: :app, except: { no_release: true }}
    task :start, roles  do
      run "cd #{current_path} && unicorn_rails -c #{unicorn_config} -E #{rails_env} -D"
    end

    {stop: 'KILL', graceful_stop: 'TERM', reload: 'USR2'}.each_pair do |t, signal|
      task t, roles do
        run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then #{try_sudo} kill -#{signal} `cat #{unicorn_pid}`; fi"
      end
    end

    task :restart, roles do
      stop
      start
    end
  end
end

