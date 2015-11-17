require 'faraday'
require 'json'
require 'uri'

module SearchKit
  class Search
    autoload :CLI, 'search_kit/search/cli'

    attr_reader :connection

    def initialize
      @connection ||= SearchKit::Client.connection
    end

    def search(slug, options)
      params   = { data: { type: "searches", attributes: options } }
      response = connection.post(slug, params)

      body = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

  end
end
