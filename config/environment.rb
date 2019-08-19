require 'bundler'
require 'pry'
require 'yaml'
require 'active_record'

Bundler.require
require_all 'app'

# ActiveRecord::Base.establish_connection({adapter: 'sqlite3', database: 'db/war_games.db'})

require_all 'lib'

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
# Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}

# DB = ActiveRecord::Base.establish_connection({
#   adapter: 'sqlite3',
#   database: 'db/tvshows.db'
# })

if ENV["ACTIVE_RECORD_ENV"] == "test"
  ActiveRecord::Migration.verbose = false
end

connection_details = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(connection_details)

