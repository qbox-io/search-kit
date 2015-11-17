require 'thor'

module SearchKit
  class Events
    class CLI < Thor
      # An extraction of the CLI command, "list", when given the `channel`
      # option.
      #
      class Pending
        include Messaging

        attr_reader :client, :channel

        def initialize(client, channel = nil)
          @client  = client
          @channel = channel
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
            info "Pending events for channel `#{channel}`:"
            events.each { |event| info(event.to_json) }
          else
            info "No pending events found for channel `#{channel}`"
          end
        end

        def events
          return @events if @events
          response = client.pending(channel)
          @events = response.fetch(:data, [])
        end

      end
    end
  end
end
