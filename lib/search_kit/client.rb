require 'faraday'

module SearchKit
  module Client
    def self.connection
      @connection ||= Faraday.new(SearchKit.config.app_uri)
    end
  end
end
