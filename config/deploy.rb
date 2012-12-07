set :application, "smorodina"
set :repository,  "git@github.com:ikarmazin/smorodina.git"
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
set :branch,      :deploy
set :deploy_to,   "/home/deployer/apps/#{application}"
set :deploy_via,  :remote_cache
set :git_enable_submodules, 1
set :rails_env, "production"

set :use_sudo,    false
set :user,        "deployer"

default_run_options[:pty] = true

#san_juan.role :app, %w(gdeslon_sphinx)

after  "deploy:symlink", "smorodina:symlink"
#after  "deploy:symlink", "smorodina:assets:build"
after  "smorodina:symlink",  "smorodina:daemons:start"
before "deploy:update_code", "smorodina:daemons:stop"

#after "deploy:symlink", 'deploy:reload_god_config'

after 'deploy:rollback', 'deploy:update_crontab'

def run_rake(task)
  run "cd #{current_path} && rake RAILS_ENV=#{rails_env} #{task}"
end


namespace :smorodina do
  desc "Make symlink for additional smorodina files"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end

  # namespace :assets do
  #   desc "Build assets with asset_packager"
  #   task :build, :roles => :app do
  #     run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  #   end
  # end

  namespace :daemons do
    desc "Stop all application daemons"
    task :stop, :roles => :app do
    end

    desc "Start all application daemons"
    task :start, :roles => :app do
    end
  end
end

namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
	#TODO
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

#desc "Hot-reload God configuration for the Resque worker"

#deploy.task :reload_god_config do

#  sudo "god stop resque"

#  sudo "god load " << File.join(deploy_to, 'current', 'config', 'god', "init.#{rails_env}.god")

#  sudo "god start resque"

#end
