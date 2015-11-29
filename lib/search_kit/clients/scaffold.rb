require 'faraday'
require 'json'

module SearchKit
  module Clients
    class Scaffold
      attr_reader :connection, :token

      def initialize
        uri = [SearchKit.config.app_uri, "scaffold"].join("/")
        @connection = Faraday.new(uri)
        @token      = SearchKit.config.app_token
      end

      def create(name, documents)
        options = {
          token: token,
          data: {
            type:          'indices',
            attributes:    { name: name },
            relationships: { documents: documents }
          }
        }

        response = connection.post('', options)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::Unprocessable if response.status == 422

        body
      end
    end
  end
end
