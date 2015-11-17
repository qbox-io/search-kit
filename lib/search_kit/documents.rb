require 'faraday'
require 'json'
require 'uri'

module SearchKit
  class Documents
    autoload :CLI, 'search_kit/documents/cli'

    attr_reader :connection

    def initialize
      @connection = SearchKit::Client.connection
    end

    def create(slug, options)
      document = { data: { type: "documents", attributes: options } }
      response = connection.post(slug, document)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

    def show(slug, id)
      response = connection.get("#{slug}/#{id}")
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::IndexNotFound if response.status == 404

      body
    end

    def update(slug, id, options)
      document = { data: { type: "documents", id: id, attributes: options } }
      response = connection.patch("#{slug}/#{id}", document)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

    def delete(slug, id)
      response = connection.delete("#{slug}/#{id}")
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::IndexNotFound if response.status == 404

      body
    end

  end
end
