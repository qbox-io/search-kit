require 'faraday'
require 'json'
require 'search_kit/thor'
require 'thor'

module SearchKit
  module CLI
    class Documents < Thor
      namespace :documents

      no_commands do
        def client
          @client ||= SearchKit::Clients::Documents.new
        end

        def messages
          @messages ||= SearchKit::Messages.new
        end
      end

      document :create
      def create(slug, document)
        document = JSON.parse(document, symbolize_names: true)
        response = client.create(slug, document)
        messages.info response.to_json
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      rescue JSON::ParserError
        messages.json_parse_error
      end

      document :delete
      def delete(slug, id)
        response = client.delete(slug, id)
        messages.info response.to_json
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :show
      def show(slug, id)
        response = client.show(slug, id)
        messages.info response.to_json
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :update
      def update(slug, id, document)
        document = JSON.parse(document, symbolize_names: true)
        response = client.update(slug, id, document)
        messages.info response.to_json
      rescue JSON::ParserError
        messages.json_parse_error
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

    end
  end
end
