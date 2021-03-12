require 'yaml'
require 'erb'

class DbConfig
  CONFIG_FILE = 'database.yml'.freeze
  ENVIRONMENT = (ENV['RACK_ENV'] || 'development').freeze

  class << self
    def get(key)
      load_settings[key.to_s]
    end

    def load_settings
      @config ||= YAML.load(ERB.new(File.read(file_path)).result)[ENVIRONMENT]
    end

    private

    def file_path
      "config/#{CONFIG_FILE}"
    end
  end
end
