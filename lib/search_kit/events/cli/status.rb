require 'thor'

module SearchKit
  class Events
    class CLI < Thor
      # An extraction of the CLI command, "all".
      #
      class Status
        include Messaging

        attr_reader :client, :id

        def initialize(client, id)
          @client = client
          @id     = id
        end

        def perform
          info "Event #{id} status: #{status}"
        rescue Errors::EventNotFound
          warning "No event found for #{id}"
        rescue Faraday::ConnectionFailed
          warning "Remote events service not found"
        rescue JSON::ParserError => error
          warning "Response unreadable: #{error}"
          error.backtrace.each(&method(:warning))
        end

        private

        def status
          response = client.show(id)

          response
            .fetch(:data, {})
            .fetch(:attributes, {})
            .fetch(:state, '')
        end

      end
    end
  end
end
