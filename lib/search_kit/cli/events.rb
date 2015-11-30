require 'thor'
require 'search_kit/thor'

module SearchKit
  module CLI
    class Events < Thor
      namespace :events

      no_commands do
        def client
          @client ||= SearchKit::Clients::Events.new
        end

        def messages
          @messages ||= SearchKit::Messages.new
        end
      end

      document :complete
      def complete(id)
        client.complete(id)
        messages.info I18n.t('cli.events.complete.success', id: id)
      rescue Errors::EventNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :pending
      def pending(channel = nil)
        events = channel ? client.pending(channel) : client.index

        message_path = %w(cli events pending success)
        message_path << (channel ? 'filtered' : 'index')
        message_path << (events.any? ? 'discovered' : 'empty')
        message = I18n.t(message_path.join('.'), channel: channel)

        messages.info(message)
        events.each { |event| messages.info(event.to_json) }
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :publish
      def publish(channel, payload)
        payload = JSON.parse(payload, symbolize_names: true)
        event   = client.publish(channel, payload)

        message = I18n.t('cli.events.publish.success',
          channel: channel,
          id:      event.id
        )

        messages.info(message)
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      rescue JSON::ParserError
        messages.json_parse_error
      end

      document :status
      def status(id)
        event  = client.show(id)
        status = event.state

        message = I18n.t('cli.events.status.success', id: id, status: status)
        messages.info(message)
      rescue Errors::EventNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

    end
  end
end
