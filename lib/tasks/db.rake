namespace :db do
  ENV['RACK_ENV'] ||= 'development'

  begin
    require 'dotenv'
    Dotenv.load
  rescue LoadError
  end

  require 'sequel'
  require_relative '../../app/initializers/01_sequal'
  require 'logger'

  Sequel.extension :migration

  DB_MIGRATION_PATH = 'db/migrations'.freeze

  desc "Prints current schema version"
  task :version do
    version =
      if DB.tables.include?(:schema_info)
        DB[:schema_info].first[:version]
      end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DB, DB_MIGRATION_PATH)
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    version =
      if DB.tables.include?(:schema_info)
        DB[:schema_info].first[:version]
      end || 0

    target = version.zero? ? 0 : (version - 1)
    args.with_defaults(target: target)

    Sequel::Migrator.run(DB, DB_MIGRATION_PATH, target: args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DB, DB_MIGRATION_PATH, target: 0)
    Sequel::Migrator.run(DB, DB_MIGRATION_PATH)
    Rake::Task['db:version'].execute
  end
end
