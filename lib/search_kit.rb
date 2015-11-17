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
    config.app_dir    = fetch("APP_DIR")
    config.app_env    = fetch("APP_ENV")
    config.app_uri    = fetch("APP_URI")
    config.config_dir = File.join(config.app_dir, "config")
    config.log_dir    = fetch("LOG_DIR")
    config.verbose    = fetch("APP_VERBOSE")
  end

  I18n.load_path += Dir.glob(File.join(config.config_dir, "locales/*.yml"))

end
