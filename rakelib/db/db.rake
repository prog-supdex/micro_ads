namespace :db do
  Sequel.extension :migration

  DB_MIGRATION_PATH = 'db/migrations'.freeze

  task :create do
    DB.execute("CREATE DATABASE #{DbConfig.get('database')}")
  end

  task :drop do
    DB.execute("DROP DATABASE IF EXISTS #{DbConfig.get('database')}")
  end

  desc "Prints current schema version"
  task :version do
    puts DB.tables.inspect
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
