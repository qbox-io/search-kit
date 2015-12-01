require 'faraday'
require 'json'

module SearchKit
  module Clients
    class Search
      attr_reader :connection, :token

      def initialize
        uri = [SearchKit.config.app_uri, "search"].join("/")
        @connection = Faraday.new(uri)
        @token      = SearchKit.config.app_token
      end

      def create(slug, options)
        params = {
          token: token, data: { type: "searches", attributes: options }
        }

        response = connection.post(slug, params)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::IndexNotFound if response.status == 404
        fail Errors::Unprocessable if response.status == 422

        SearchKit::Models::Search.new(body.fetch(:data, {}))
      end

    end
  end
end
