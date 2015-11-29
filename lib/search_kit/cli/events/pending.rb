require 'thor'

module SearchKit
  class CLI < Thor
    class Events < Thor
      # An extraction of the CLI command, "list", when given the `channel`
      # option.
      #
      class Pending
        attr_reader :client, :channel, :messages

        def initialize(client, channel = nil)
          @client  = client
          @channel = channel
          @messages = Messages.new
        end

        def perform
          report_events
        rescue Faraday::ConnectionFailed
          messages.no_service
        rescue JSON::ParserError => error
          messages.unreadable(error)
          error.backtrace.each(&messages.method(:warning))
        end

        private

        def report_events
          namespace = 'cli.events.pending.success'
          if events.any?
            message = I18n.t("#{namespace}.discovered.list", channel: channel)

            messages.info(message)
            events.each { |event| messages.info(event.to_json) }
          else
            message = I18n.t("#{namespace}.empty.list", channel: channel)
            messages.info(message)
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
