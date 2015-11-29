require 'thor'

module SearchKit
  class CLI < Thor
    class Events < Thor
      # An extraction of the CLI command, "pending".  When the pending comand
      # is not given any parameters, it looks for all pending events despite
      # of channel - or in other words, the index of events.
      #
      class List
        attr_reader :client, :messages

        def initialize(client)
          @client   = client
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
          if events.any?
            messages.info I18n.t('events.pending.success.list')
            events.each { |event| messages.info(event.to_json) }
          else
            messages.info I18n.t('events.pending.success.empty')
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
