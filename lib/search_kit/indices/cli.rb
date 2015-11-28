require 'thor'

module SearchKit
  class Indices
    class CLI < Thor
      include Messaging

      namespace :indices

      desc "show slug", "View an index"
      def show(slug)
        response = client.show(slug)
        info response.to_json
      rescue Errors::IndexNotFound
        warning "No index for that slug found"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "create NAME", "Create an index"
      def create(name)
        response = client.create(name)
        info response.to_json
      rescue Errors::BadRequest
        warning "Bad create request"
      rescue Errors::Unprocessable
        warning "Options given unprocessable"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "scaffold NAME JSON", "Create an index with a list of documents"
      def scaffold(name, json = "{}")
        documents = JSON.parse(json, symbolize_names: true)
        response  = client.scaffold(name, documents)
        info response.to_json
      rescue JSON::ParserError
        warning "Documents must be given in the form of a JSON array string"
      rescue Errors::BadRequest
        warning "Bad create request"
      rescue Errors::Unprocessable
        warning "Options given unprocessable"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "update SLUG", "Update an index"
      option :name
      def update(slug)
        response = client.update(slug, options)
        info response.to_json
      rescue Errors::BadRequest
        warning "Bad update request"
      rescue Errors::IndexNotFound
        warning "No index for that slug found"
      rescue Errors::Unprocessable
        warning "Options given unprocessable"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "archive SLUG", "Archive an index"
      def archive(slug)
        response = client.delete(slug)
        info response.to_json
      rescue Errors::IndexNotFound
        warning "No index for that slug found"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      private

      def client
        @client ||= Indices.new
      end

    end
  end
end
