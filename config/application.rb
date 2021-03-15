class Application < Roda
  plugin :symbol_status

  opts[:root] = File.expand_path('../', __dir__)
end
