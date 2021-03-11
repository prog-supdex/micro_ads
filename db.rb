begin
  require_relative '.env.rb'
rescue LoadError
end

require 'sequel/core'

DB = Sequel.connect(ENV.delete('MICRO_ADS_DATABASE_URL'))
