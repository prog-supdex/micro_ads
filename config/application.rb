class Application < Roda
  plugin :environments
  plugin :symbol_status

  opts[:root] = File.expand_path('../', __dir__)
end
