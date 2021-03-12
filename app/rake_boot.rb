begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']

require 'sequel'

def require_glob(glob)
  Dir.glob(glob).sort.each do |path|
    require path
  end
end

require_glob("#{__dir__}/initializers/*.rb")
