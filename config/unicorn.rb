PROJECT_BASE_PATH =   "/home/deployer/apps/smorodina/current"
PROJECT_SHARED_PATH = "/home/deployer/apps/smorodina/shared"
ENV['RAILS_ENV'] = 'production'
worker_processes(4)
user('deployer','deployer')
timeout 40
listen "#{PROJECT_SHARED_PATH}/sockets/unicorn.sock"
working_directory "#{PROJECT_BASE_PATH}"
pid "#{PROJECT_BASE_PATH}/tmp/pids/unicorn.pid"
stderr_path "#{PROJECT_BASE_PATH}/log/unicorn.stderr.log"
stdout_path "#{PROJECT_BASE_PATH}/log/unicorn.stdout.log"

preload_app true

GC.respond_to?(:copy_on_write_friendly=) && (GC.copy_on_write_friendly = true)

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{PROJECT_SHARED_PATH}/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
