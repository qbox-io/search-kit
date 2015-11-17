require 'thor'

module SearchKit
  class Events
    class CLI < Thor
      # An extraction of the CLI command, "complete".
      #
      class Complete
        include Messaging

        attr_reader :client, :id

        def initialize(client, id)
          @client = client
          @id     = id
        end

        def perform
          client.complete(id)

          info "Event #{id} completed"
        rescue Errors::EventNotFound
          warning "No event found for #{id}"
        rescue Faraday::ConnectionFailed
          warning "Remote events service not found"
        rescue JSON::ParserError => error
          warning "Response unreadable: #{error}"
          error.backtrace.each(&method(:warning))
        end

      end
    end
  end
end
