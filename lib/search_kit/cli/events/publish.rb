require 'thor'

module SearchKit
  class CLI < Thor
    class Events < Thor
      # An extraction of the CLI command, "publish".
      #
      class Publish
        attr_reader :client, :channel, :messages, :payload

        def initialize(client, channel, options = {})
          @channel  = channel
          @client   = client
          @messages = Messages.new
          @payload  = options.fetch('payload', {})
        end

        def perform
          message = I18n.t('cli.events.publish.success', uri: status_uri)
          messages.info(message)
        rescue Faraday::ConnectionFailed
          messages.no_service
        rescue Errors::PublicationFailed => error
          message = I18n.t('cli.events.publish.failure', error: error)
          messages.warning(message)
        rescue JSON::ParserError => error
          messages.unreadable(error)
          error.backtrace.each(&messages.method(:warning))
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
