require 'faraday'
require 'json'

module SearchKit
  module Clients
    class Keys
      attr_reader :connection, :token

      def initialize
        uri = [SearchKit.config.app_uri, "keys"].join("/")
        @connection = Faraday.new(uri)
        @token      = SearchKit.config.app_token
      end

      def create(name, options = {})
        options = {
          token: token,
          data: { type: 'keys', attributes: { name: name }.merge(options) }
        }

        response = connection.post('', options)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::Unprocessable if response.status == 422

        body
      end

      def expire(id)
        response = connection.delete(id, token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized if response.status == 401
        fail Errors::KeyNotFound  if response.status == 404

        body
      end

      def index
        response = connection.get("", token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized if response.status == 401

        body
      end

      def show(id)
        response = connection.get(id, token: token)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::Unauthorized if response.status == 401
        fail Errors::KeyNotFound  if response.status == 404

        body
      end

      def update(id, options)
        options  = {
          token: token, data: { type: 'keys', attributes: options }
        }

        response = connection.patch(id, options)
        body     = JSON.parse(response.body, symbolize_names: true)

        fail Errors::BadRequest    if response.status == 400
        fail Errors::Unauthorized  if response.status == 401
        fail Errors::KeyNotFound   if response.status == 404
        fail Errors::Unprocessable if response.status == 422

        body
      end

    end
  end
end
