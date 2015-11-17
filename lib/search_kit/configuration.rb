require 'ostruct'
require 'yaml'
require 'uri'
require 'user_config'

module SearchKit
  module Configuration

    def configure
      yield(config) if block_given?
    end

    def config
      return @config if @config
      root   = UserConfig.new(".search-kit")
      yaml   = root['config.yml']
      config = OpenStruct.new

      yaml.each { |key, value| config.send("#{key}=", value) }
      @config = config
    end

    def set_config(key, value)
      root = UserConfig.new(".search-kit")
      yaml = root['config.yml']

      yaml[key] = value
      yaml.save
    end

    def show_config(key)
      root = UserConfig.new(".search-kit")
      root['config.yml'][key]
    end

    def fetch(key)
      ENV.fetch(key, show_config(key.downcase) || default(key.to_sym))
    end

    private

    def default(key)
      default_table = {
        APP_URI:     "http://localhost:8080",
        APP_ENV:     "development",
        APP_DIR:     File.expand_path("../../", __dir__),
        APP_VERBOSE: true,
        LOG_DIR:     default_log_dir
      }.fetch(key, nil)
    end

    def default_log_dir
      Dir.mkdir('log') unless Dir.exist?('log')

      'log'
    end

  end
end
