puts Settings.db.to_hash

Sequel.connect(Settings.db.to_hash)

Sequel::Model.db.extension(:pagination)

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_or_create: true

Sequel.default_timezone = :utc
