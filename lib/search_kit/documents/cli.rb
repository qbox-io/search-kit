require 'thor'

module SearchKit
  class Documents
    class CLI < Thor
      include Messaging

      namespace :documents

      desc "show SLUG ID", "View a document"
      def show(slug, id)
        response = client.show(slug, id)
        info response.to_json
      rescue Errors::IndexNotFound
        warning "No index for that slug found (could also be missing doc)"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "create SLUG DOCUMENT", "Create a document with a json string"
      def create(slug, document)
        document = JSON.parse(document, symbolize_names: true)
        response = client.create(slug, document)
        info response.to_json
      rescue JSON::ParserError
        warning "Document must be given in the form of a JSON string"
      rescue Errors::IndexNotFound
        warning "No index for #{slug} found"
      rescue Errors::BadRequest
        warning "Bad request given"
      rescue Errors::Unprocessable
        warning "Options given unprocessable"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "update SLUG ID DOCUMENT", "Update a document with a json string"
      def update(slug, id, document)
        document = JSON.parse(document, symbolize_names: true)
        response = client.update(slug, id, document)
        info response.to_json
      rescue JSON::ParserError
        warning "Document must be given in the form of a JSON string"
      rescue Errors::BadRequest
        warning "Bad request given"
      rescue Errors::IndexNotFound
        warning "Unable to find either the given index or document"
      rescue Errors::Unprocessable
        warning "Options given unprocessable"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "delete SLUG ID", "Delete a document"
      def delete(slug, id)
        response = client.delete(slug, id)
        info response.to_json
      rescue Errors::IndexNotFound
        warning "Unable to find either the given index or document"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      private

      def client
        @client ||= Documents.new
      end

    end
  end
end
