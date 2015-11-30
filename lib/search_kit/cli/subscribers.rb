require 'thor'
require 'search_kit/thor'

module SearchKit
  class CLI < Thor
    class Subscribers < Thor
      namespace :subscribers

      no_commands do
        def client
          @client ||= SearchKit::Clients::Subscribers.new
        end

        def messages
          @messages ||= Messages.new
        end
      end

      document :create
      def create(email, password)
        subscriber = client.create(email: email, password: password)
        messages.info(subscriber.to_json)
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :info
      def info
        subscriber = client.info
        messages.info(subscriber.to_json)
      rescue Errors::SubscriberNotFound
        messages.not_found
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

    end
  end
end
