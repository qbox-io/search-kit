require 'thor'
require 'search_kit/thor'

module SearchKit
  class CLI < Thor
    class Indices < Thor
      namespace :indices

      document :archive
      def archive(slug)
        response = client.delete(slug)
        messages.info response.to_json
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :create
      def create(name)
        response = client.create(name)
        messages.info response.to_json
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :scaffold
      def scaffold(name, json = "{}")
        documents = JSON.parse(json, symbolize_names: true)
        response  = client.scaffold(name, documents)

        messages.info response.to_json
      rescue JSON::ParserError
        messages.json_parse_error
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.bad_request
      end

      document :show
      def show(slug)
        response = client.show(slug)
        messages.info response.to_json
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      document :update
      option :name
      def update(slug)
        response = client.update(slug, options)
        messages.info response.to_json
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      private

      def client
        @client ||= Indices.new
      end

      def messages
        @messages ||= Messages.new
      end

    end
  end
end
