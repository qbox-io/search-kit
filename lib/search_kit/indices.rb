require 'faraday'
require 'json'

module SearchKit
  class Indices
    autoload :CLI, 'search_kit/indices/cli'

    attr_reader :connection, :token

    def initialize
      uri = [SearchKit.config.app_uri, "indices"].join("/")
      @connection = Faraday.new(uri)
      @token      = SearchKit.config.app_token
    end

    def archive(slug)
      response = connection.delete(slug, token: token)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::Unauthorized  if response.status == 401
      fail Errors::IndexNotFound if response.status == 404

      body
    end

    def create(name)
      options = {
        token: token,
        data: { type: 'indices', attributes: { name: name } }
      }

      response = connection.post('', options)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::Unauthorized  if response.status == 401
      fail Errors::BadRequest    if response.status == 400
      fail Errors::Unprocessable if response.status == 422

      body
    end

    def show(slug)
      response = connection.get(slug, token: token)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::Unauthorized  if response.status == 401
      fail Errors::IndexNotFound if response.status == 404

      body
    end

    def update(slug, options)
      options  = {
        token: token,
        data: { type: 'indices', attributes: options }
      }

      response = connection.patch(slug, options)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::Unauthorized  if response.status == 401
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

  end
end
