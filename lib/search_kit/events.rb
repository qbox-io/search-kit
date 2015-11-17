require 'faraday'
require 'json'
require 'uri'

module SearchKit
  class Events
    autoload :CLI,     'search_kit/events/cli'
    autoload :Publish, 'search_kit/events/publish'

    attr_reader :connection

    def initialize
      @connection = SearchKit::Client.connection
    end

    def complete(id)
      response = connection.delete("/api/events/#{id}")
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::EventNotFound if response.status == 404

      body
    end

    def index
      response = connection.get('/api/events')

      JSON.parse(response.body, symbolize_names: true)
    end

    def show(id)
      response = connection.get("/api/events/#{id}")
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::EventNotFound if response.status == 404

      body
    end

    def pending(channel)
      response = connection.get("/api/events?filter[channel]=#{channel}")

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
