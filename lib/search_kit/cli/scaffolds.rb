require 'faraday'
require 'json'
require 'search_kit/thor'
require 'thor'

module SearchKit
  module CLI
    class Scaffolds < Thor
      namespace :scaffolds

      no_commands do
        def client
          @client ||= SearchKit::Clients::Scaffold.new
        end

        def messages
          @messages ||= Messages.new
        end
      end

      document :scaffold
      def create(name, json = "[]")
        documents = JSON.parse(json, symbolize_names: true)
        response  = client.create(name, documents)

        messages.info response.to_json
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::BadRequest
        messages.bad_request
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
