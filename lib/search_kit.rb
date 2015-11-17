require 'bundler/setup'
require 'i18n'
require "search_kit/version"

module SearchKit
  autoload :CLI,           'search_kit/cli'
  autoload :Client,        'search_kit/client'
  autoload :Configuration, 'search_kit/configuration'
  autoload :Documents,     'search_kit/documents'
  autoload :Errors,        'search_kit/errors'
  autoload :Events,        'search_kit/events'
  autoload :Indices,       'search_kit/indices'
  autoload :Logger,        'search_kit/logger'
  autoload :Messaging,     'search_kit/messaging'
  autoload :Search,        'search_kit/search'

  def self.logger
    @logger ||= Logger.new
  end

  extend Configuration

  configure do |config|
    config.app_uri = ENV.fetch("APP_URI", "http://localhost:8080")
    config.app_env = ENV.fetch("APP_ENV", "development")
    config.app_dir = ENV.fetch("APP_DIR", nil) || Dir.pwd
    config.verbose = ENV.fetch("APP_VERBOSE", true)

    config.log_dir = ENV.fetch("LOG_DIR") do
      Dir.mkdir('log') unless Dir.exist?('log')

      'log'
    end

    config.config_dir     = File.join(config.app_dir, "config")
    config.token_strategy = -> token { nil }
  end

  I18n.load_path += Dir.glob(File.join(config.config_dir, "locales/*.yml"))

end
