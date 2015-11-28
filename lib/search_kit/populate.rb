require 'faraday'
require 'json'

module SearchKit
  class Populate
    attr_reader :connection, :token

    def initialize
      uri = [SearchKit.config.app_uri, "populate"].join("/")
      @connection = Faraday.new(uri)
      @token      = SearchKit.config.app_token
    end

    def create(slug, documents)
      documents = documents.map do |document|
        { type: 'documents', attributes: document }
      end

      params   = { token: token, data: documents }
      response = connection.post(slug, params)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::Unauthorized  if response.status == 401
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

    def update(slug, documents)
      documents = documents.map do |document|
        {
          type:      'documents',
          id:         document.fetch(:id, nil),
          attributes: document
        }
      end

      params   = { token: token, data: documents }
      response = connection.patch(slug, params)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::Unauthorized  if response.status == 401
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

    def delete(slug, ids)
      documents = ids.map do |id|
        { type: 'documents', id: id, attributes: { id: id } }
      end

      params   = { token: token, data: documents }
      response = connection.delete(slug, params)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Errors::BadRequest    if response.status == 400
      fail Errors::Unauthorized  if response.status == 401
      fail Errors::IndexNotFound if response.status == 404
      fail Errors::Unprocessable if response.status == 422

      body
    end

  end
end
