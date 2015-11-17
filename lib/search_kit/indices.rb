require 'faraday'
require 'json'
require 'uri'

module SearchKit
  class Indices
    autoload :CLI, 'search_kit/indices/cli'

    attr_reader :connection

    def initialize
      uri = [SearchKit.config.app_uri, "indices"].join("/")
      @connection = Faraday.new(uri)
    end

    def show(slug)
      response = connection.get(slug)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::IndexNotFound if response.status == 404

      body
    end

    def create(name)
      options  = { data: { type: 'indices', attributes: { name: name } } }
      response = connection.post('/', options)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::Unprocessable if response.status == 422
      fail Errors::BadRequest    if response.status == 400

      body
    end

    def update(slug, options)
      options  = { data: { type: 'indices', attributes: options } }
      response = connection.patch(slug, options)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

    def delete(slug)
      response = connection.delete(slug)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::IndexNotFound if response.status == 404

      body
    end

  end
end
