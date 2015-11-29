require 'thor'

module SearchKit
  class CLI < Thor
    class Events < Thor
      # An extraction of the CLI command, "all".
      #
      class Status
        attr_reader :client, :id, :messages

        def initialize(client, id)
          @client   = client
          @messages = Messages.new
          @id       = id
        end

        def perform
          message = I18n.t('cli.events.status.success', id: id, status: status)
          messages.info(message)
        rescue Errors::EventNotFound
          messages.not_found
        rescue Faraday::ConnectionFailed
          messages.no_service
        rescue JSON::ParserError => error
          messages.unreadable(error)
          error.backtrace.each(&messages.method(:warning))
        end

        private

        def status
          response = client.show(id)
          response.fetch(:data, {}).fetch(:attributes, {}).fetch(:state, '')
        end

      end
    end
  end
end
