class Application < Roda
  plugin :symbol_status

  opts[:root] = File.expand_path('../Gemfile', __dir__)
end
