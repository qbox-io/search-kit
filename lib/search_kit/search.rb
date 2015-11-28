require 'faraday'
require 'json'

module SearchKit
  class Search
    autoload :CLI, 'search_kit/search/cli'

    attr_reader :connection

    def initialize
      uri = [SearchKit.config.app_uri, "search"].join("/")
      @connection = Faraday.new(uri)
    end

    def search(slug, options)
      params   = {
        token: SearchKit.config.app_token,
        data: { type: "searches", attributes: options }
      }
      response = connection.post(slug, params)

      body = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

  end
end
