require 'faraday'
require 'json'

module SearchKit
  module Clients
    class Documents
      attr_reader :connection, :token

      def initialize
        uri = [SearchKit.config.app_uri, "documents"].join("/")
        @connection = Faraday.new(uri)
        @token      = SearchKit.config.app_token
      end

      def create(slug, options)
        document = {
          token: token,
          data: { type: "documents", attributes: options }
        }

        response = connection.post(slug, document)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::IndexNotFound if response.status == 404
        fail Errors::Unprocessable if response.status == 422

        body
      end

      def delete(slug, id)
        response = connection.delete("#{slug}/#{id}", token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized  if response.status == 401
        fail Errors::IndexNotFound if response.status == 404

        body
      end

      def show(slug, id)
        response = connection.get("#{slug}/#{id}", token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized  if response.status == 401
        fail Errors::IndexNotFound if response.status == 404

        body
      end

      def update(slug, id, options)
        document = {
          token: token,
          data: { type: "documents", id: id, attributes: options }
        }

        response = connection.patch("#{slug}/#{id}", document)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::IndexNotFound if response.status == 404
        fail Errors::Unprocessable if response.status == 422

        body
      end

    end
  end
end
