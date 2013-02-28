
def setup_db_cleaner
  #http://stackoverflow.com/questions/5433690/capybaraselemium-how-to-initialize-database-in-an-integration-test-code-and-ma
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean_with :truncation
end
