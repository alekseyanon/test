namespace :db do
  desc """Copying database.yml.example -> database.yml,
          filling in values like db username / password"""
  task :configure, :username, :password do |t, args|
    `cp ./config/database.yml.example ./config/database.yml`
    `sed -i 's/username: smorodina/username: #{args[:username]}/g' ./config/database.yml` if args[:username]
    `sed -i 's/password:/password: #{args[:password]}/g' ./config/database.yml` if args[:password]
  end
end
