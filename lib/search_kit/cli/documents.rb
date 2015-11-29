require 'thor'
require 'search_kit/thor'

module SearchKit
  class CLI < Thor
    class Documents < Thor
      namespace :documents

      document :show
      def show(slug, id)
        response = client.show(slug, id)
        messages.info response.to_json
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :create
      def create(slug, document)
        document = JSON.parse(document, symbolize_names: true)
        response = client.create(slug, document)
        messages.info response.to_json
      rescue JSON::ParserError
        messages.json_parse_error
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unprocessable
        messages.unprocessable
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

      document :delete
      def delete(slug, id)
        response = client.delete(slug, id)
        messages.info response.to_json
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      private

      def client
        @client ||= Documents.new
      end

      def messages
        @messages ||= Messages.new
      end

    end
  end
end
