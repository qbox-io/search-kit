require 'faraday'
require 'json'
require 'uri'

module SearchKit
  class Events
    autoload :CLI,     'search_kit/events/cli'
    autoload :Publish, 'search_kit/events/publish'
    autoload :Poll,    'search_kit/events/poll'

    attr_reader :connection

    def initialize
      uri = [SearchKit.config.app_uri, "events"].join("/")
      @connection = Faraday.new(uri)
    end

    def complete(id)
      response = connection.delete(id)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::EventNotFound if response.status == 404

      body
    end

    def index
      response = connection.get

      JSON.parse(response.body, symbolize_names: true)
    end

    def show(id)
      response = connection.get(id)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::EventNotFound if response.status == 404

      body
    end

    def pending(channel)
      response = connection.get('', "filter[channel]" => channel)

      JSON.parse(response.body, symbolize_names: true)
    end

    def publish(channel, payload)
      action = Publish.new(
        channel:    channel,
        connection: connection,
        payload:    payload
      )

      action.perform
    end

  end
end
