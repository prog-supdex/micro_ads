namespace :db do
  if ENV['RACK_ENV'] == 'development'
    require 'dotenv/load'
  end

  require 'sequel/core'
  Sequel.extension :migration

  require 'config'
  require_relative '../../config/initializers/config'

  DB_MIGRATION_PATH = File.expand_path('../../db/migrations', __dir__).freeze
  DB_SEED_PATH = File.expand_path('../../db/seeds', __dir__).freeze
  DB_SCHEMA_PATH = File.expand_path('../../db', __dir__).freeze
  DB_SCHEMA_FILE_NAME = 'schema.rb'.freeze
  DB = Sequel.connect(Settings.db.to_hash)

  task :create do
    DB.execute("CREATE DATABASE #{Settings.db.database}")
  end

  task :drop do
    DB.execute("DROP DATABASE IF EXISTS #{Settings.db.database}")
  end

  desc 'Prints current schema version'
  task :version do
    version =
      if DB.tables.include?(:schema_info)
        DB[:schema_info].first[:version]
      end || 0

    puts "Schema Version: #{version}"
  end

  desc 'Perform migration up to latest migration available'
  task :migrate do |t, args|
    db_migrate(args[:version] || db_migrations.last)
  end

  desc "Perform rollback to specified target or previous version as default"
  task :rollback, [:version] do |t, args|
    version =
      if DB.tables.include?(:schema_info)
        DB[:schema_info].first[:version]
      end || 0

    target = version.zero? ? 0 : (version - 1)
    args.with_defaults(target: target)

    db_migrate(args[:target].to_i)
  end

  desc 'Perform migration reset (full rollback and migration)'
  task :reset do
    db_migrate(0)
    db_migrate
  end

  namespace :schema do
    task :dump do
      DB.extension(:schema_dumper)

      if Dir.exists?(DB_SCHEMA_PATH)
        File.open(File.join(DB_SCHEMA_PATH, DB_SCHEMA_FILE_NAME).to_s, 'w') do |file|
          file << DB.dump_schema_migration(indexes: true, foreign_keys: true)
        end

      else
        abort "The db/ directory doesn't exist, please create it."
      end
    end
  end

  def db_migrations
    Dir["#{DB_MIGRATION_PATH}/*.rb"].map { |f| File.basename(f) }.sort
  end

  def db_migrate(version = db_migrations.last)
    puts "Migrating database to version #{version}"
    Sequel::Migrator.run(DB, DB_MIGRATION_PATH, target: version.to_i)

    Rake::Task['db:schema:dump'].execute
    Rake::Task['db:version'].execute
  end

  def require_dir(path)
    Dir["#{path}/**/*.rb"].each { |file| require file }
  end
end
