class Application < Roda
  plugin :json
  plugin :environments
  plugin :symbol_status

  opts[:root] = File.expand_path('../', __dir__)
end
