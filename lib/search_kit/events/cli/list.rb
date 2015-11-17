require 'thor'

module SearchKit
  class Events
    class CLI < Thor
      # An extraction of the CLI command, "pending".  When the pending comand
      # is not given any parameters, it looks for all pending events despite
      # of channel - or in other words, the index of events.
      #
      class List
        include Messaging

        attr_reader :client

        def initialize(client)
          @client = client
        end

        def perform
          report_events
        rescue Faraday::ConnectionFailed
          warning "Remote events service not found"
        rescue JSON::ParserError => error
          warning "Response unreadable: #{error}"
          error.backtrace.each(&method(:warning))
        end

        private

        def report_events
          if events.any?
            info "Pending events:"
            events.each { |event| info(event.to_json) }
          else
            info "No pending events found"
          end
        end

        def events
          return @events if @events
          response = client.index
          @events = response.fetch(:data, [])
        end

      end
    end
  end
end
