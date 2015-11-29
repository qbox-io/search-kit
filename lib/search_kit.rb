require 'bundler/setup'
require 'i18n'
require "search_kit/version"
require "search_kit/thor"

module SearchKit
  autoload :CLI,           'search_kit/cli'
  autoload :Clients,       'search_kit/clients'
  autoload :Configuration, 'search_kit/configuration'
  autoload :Errors,        'search_kit/errors'
  autoload :Logger,        'search_kit/logger'
  autoload :Messages,      'search_kit/messages'
  autoload :Models,        'search_kit/models'
  autoload :Polling,       'search_kit/polling'

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
