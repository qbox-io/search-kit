require 'thor'

module SearchKit
  class Events
    class CLI < Thor
      # An extraction of the CLI command, "publish".
      #
      class Publish
        include Messaging

        attr_reader :client, :channel, :payload

        def initialize(client, channel, options = {})
          @client  = client
          @channel = channel
          @payload = options.fetch('payload', {})
        end

        def perform
          info "Event published, status @ #{status_uri}"
        rescue Faraday::ConnectionFailed
          warning "Remote events service not found"
        rescue Errors::PublicationFailed => error
          warning "Publication failed: #{error}"
        rescue JSON::ParserError => error
          warning "Response unreadable: #{error}"
          error.backtrace.each(&method(:warning))
        end

        private

        def status_uri
          return @status_uri if @status_uri
          response = client.publish(channel, payload)
          links    = response.fetch(:data, {}).fetch(:links, {})
          @status_uri = links.fetch(:self, '')
        end

      end
    end
  end
end
