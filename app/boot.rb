begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']

require 'roda'
require 'sequel'
require 'active_job'
require 'active_support'
require 'fast_jsonapi'
require 'logger'
require 'dry-initializer'
require 'geocoder'
require 'pagy'

def require_glob(glob)
  Dir.glob(glob).sort.each do |path|
    require path
  end
end

require_glob("#{__dir__}/initializers/*.rb")
require_glob("#{__dir__}/models/*.rb")
require_glob("#{__dir__}/serializers/*.rb")
require_glob("#{__dir__}/services/*.rb")
require_glob("#{__dir__}/services/**/*.rb")
require_glob("#{__dir__}/jobs/*.rb")
require_glob("#{__dir__}/jobs/**/*.rb")
require_glob("#{__dir__}/helpers/*.rb")
