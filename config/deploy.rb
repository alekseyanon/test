set :application, "smorodina"
set :repository,  "git@github.com:smorodina/smorodina.git"
default_environment['PATH'] = "/usr/local/bin:/usr/bin:/bin:/opt/bin:$PATH"
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "5.9.120.46"                          # Your HTTP server, Apache/etc
role :app, "5.9.120.46"                          # This may be the same as your `Web` server
role :db,  "5.9.120.46", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


set :scm,         :git
set :branch,      '45491663-search-where-to-go-layout'
set :deploy_to,   "/home/deployer/apps/#{application}"
#set :deploy_via,  :remote_cache
set :git_enable_submodules, 1
set :rails_env,   'production'

set :use_sudo,    false
set :user,        'deployer'

default_run_options[:pty] = true

before 'deploy:update_code', 'smorodina:daemons:stop'
after  'deploy:update_code', 'smorodina:symlink'
#after  'smorodina:symlink',  'smorodina:db'
after  'smorodina:db',       'smorodina:daemons:start'

def run_rake(task)
  run "cd #{current_path} && rake RAILS_ENV=#{rails_env} #{task}"
end


namespace :smorodina do
  desc "Make symlink for additional smorodina files"
  task :symlink do
    run "rm -f #{current_path} && ln -s #{release_path} #{current_path}" #TODO remove hack, capistrano should do this
    run "ln -nfs #{shared_path}/config/database.yml        #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/social_services.yml #{release_path}/config/social_services.yml"
    run "ln -nfs #{shared_path}/uploads                    #{release_path}/public/uploads"
    run "ln -nfs $HOME/osm/RU-LEN.osm.bz2                  #{release_path}/RU-LEN.osm.bz2"
  end

  task :db do
    run_rake 'db:rebuild_from_template'
  end

  namespace :daemons do
    desc "Stop all application daemons"
    task :stop, :roles => :app do
      unicorn.graceful_stop
    end

    desc "Start all application daemons"
    task :start, :roles => :app do
      unicorn.start
    end
  end

  set :rails_env, :production
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

