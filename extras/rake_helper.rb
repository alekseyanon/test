class RakeHelper
  def self.database; Rails.configuration.database_configuration[Rails.env]['database'] end
  def self.username; Rails.configuration.database_configuration[Rails.env]['username'] end

  def self.run_sql(name)
    puts "--- Running sql script : #{name} ---"
    puts command = "psql #{database} --username=#{username} < db/sql/#{name}.sql"
    puts `#{command}`
  end
end

RH = RakeHelper