require 'faraday'
require 'json'
require 'search_kit/thor'
require 'thor'

module SearchKit
  module CLI
    class Indices < Thor
      namespace :indices

      no_commands do
        def client
          @client ||= SearchKit::Clients::Indices.new
        end

        def messages
          @messages ||= SearchKit::Messages.new
        end
      end

      document :archive
      def archive(slug)
        response = client.archive(slug)
        messages.info response.to_json
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :create
      def create(name)
        response = client.create(name)
        messages.info response.to_json
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :show
      def show(slug)
        response = client.show(slug)
        messages.info response.to_json
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :update
      def update(slug, update_json)
        options  = JSON.parse(update_json, symbolize_names: true)
        response = client.update(slug, options)
        messages.info response.to_json
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      rescue JSON::ParserError
        messages.json_parse_error
      end

    end
  end
end
