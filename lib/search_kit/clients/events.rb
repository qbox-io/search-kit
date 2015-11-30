require 'faraday'
require 'json'

module SearchKit
  module Clients
    class Events
      attr_reader :connection, :token

      def initialize
        uri = [ SearchKit.config.app_uri, "events" ].join("/")
        @connection = Faraday.new(uri)
        @token      = SearchKit.config.app_token
      end

      def complete(id)
        response = connection.delete(id, token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized  if response.status == 401
        fail Errors::EventNotFound if response.status == 404

        SearchKit::Models::Event.new body.fetch(:data, {})
      end

      def index
        response = connection.get(token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized if response.status == 401

        SearchKit::Models::Events.new body.fetch(:data, [])
      end

      def pending(channel)
        params   = { "filter[channel]" => channel, token: token }
        response = connection.get('', params)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::Unprocessable if response.status == 422

        SearchKit::Models::Events.new body.fetch(:data, [])
      end

      def publish(channel, payload)
        params = {
          token: token,
          data: {
            type: 'events',
            attributes: { channel: channel, payload: payload }
          }
        }

        response = connection.post("", params)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::Unprocessable if response.status == 422

        SearchKit::Models::Event.new body.fetch(:data, {})
      end

      def show(id)
        response = connection.get(id, token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized  if response.status == 401
        fail Errors::EventNotFound if response.status == 404

        SearchKit::Models::Event.new body.fetch(:data, {})
      end

    end
  end
end
