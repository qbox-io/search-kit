require 'thor'

module SearchKit
  class CLI < Thor
    class Events < Thor
      # An extraction of the CLI command, "complete".
      #
      class Complete
        attr_reader :client, :id, :messages

        def initialize(client, id)
          @client   = client
          @id       = id
          @messages = Messages.new
        end

        def perform
          client.complete(id)

          messages.info I18n.t('cli.events.complete.success', id: id)
        rescue Errors::EventNotFound
          messages.not_found
        rescue Faraday::ConnectionFailed
          messages.no_service
        rescue JSON::ParserError => error
          messages.unreadable(error)
          error.backtrace.each(&messages.method(:warning))
        end

      end
    end
  end
end
