require 'faraday'
require 'json'

module SearchKit
  class Subscribers
    autoload :CLI, 'search_kit/subscribers/cli'

    attr_reader :connection, :token

    def initialize
      uri = [SearchKit.config.app_uri, "subscribers"].join("/")
      @connection = Faraday.new(uri)
      @token      = SearchKit.config.app_token
    end

    def create(options = {})
      options  = { data: { type: 'subscribers', attributes: options } }
      response = connection.post("", options)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::Unprocessable if response.status == 422

      body
    end

    def info
      response = connection.get("", token: token)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::Unauthorized       if response.status == 401
      fail Errors::SubscriberNotFound if response.status == 404

      body
    end

    def update(options = {})
      options  = {
        token: token, data: { type: 'subscribers', attributes: options }
      }

      response = connection.patch("", options)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest         if response.status == 400
      fail Errors::Unauthorized       if response.status == 401
      fail Errors::SubscriberNotFound if response.status == 404
      fail Errors::Unprocessable      if response.status == 422

      body
    end

  end
end
