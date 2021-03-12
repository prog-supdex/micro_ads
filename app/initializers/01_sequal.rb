DB = Sequel.connect(
  adapter: :postgres,
  user: DbConfig.get('username'),
  password: DbConfig.get('password'),
  host: DbConfig.get('host'),
  port: DbConfig.get('port') || 5432,
  database: DbConfig.get('database')
)

if ENV['RACK_ENV'] == 'development'
  Sequel::Model.cache_associations = false
end

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :prepared_statements
Sequel::Model.plugin :subclasses unless ENV['RACK_ENV'] == 'development'

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'
  require 'logger'
  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::FATAL if ENV['RACK_ENV'] == 'test'
  DB.loggers << LOGGER
end

unless ENV['RACK_ENV'] == 'development'
  Sequel::Model.freeze_descendents
  DB.freeze
end
