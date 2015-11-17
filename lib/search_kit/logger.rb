require 'forwardable'

module SearchKit
  # The SearchKit logger, handled in its own class mainly for the purpose
  # of allowing the daemonized process to quickly and cleanly reinitialize its
  # connection to logfiles even after its process has been decoupled.
  #
  class Logger
    extend Forwardable

    attr_reader :logger

    def_delegators :logger, :info, :warn

    def initialize
      environment = SearchKit.config.app_env

      loginfo = [
        SearchKit.config.app_dir,
        SearchKit.config.log_dir,
        "service-layer-#{environment}.log"
      ]

      logpath = File.join(*loginfo)
      default = ::Logger.new(logpath, "daily")

      @logger = SearchKit.config.logger || default
    end
  end

end
