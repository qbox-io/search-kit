require 'thor'

module SearchKit
  class CLI < Thor
    class Search < Thor
      module Actions
        class Search
          def self.perform(options = {})
            new(options).perform
          end

          attr_reader :client, :messages, :phrase, :slug

          def initialize(options = {})
            @client   = options.fetch(:client)
            @messages = Messages.new
            @phrase   = options.fetch(:phrase, nil)
            @slug     = options.fetch(:slug)
          end

          def perform
            SearchResult.new(search_response)
          rescue Errors::IndexNotFound
            messages.not_found
          rescue Errors::BadRequest
            messages.bad_request
          rescue Errors::Unprocessable
            messages.unprocessable
          rescue Faraday::ConnectionFailed
            messages.no_service
          end

          private

          def search_response
            client.search(slug, phrase: phrase)
          end

          class SearchResult
            attr_reader :attributes

            def initialize(response)
              @attributes = response.fetch(:data, {}).fetch(:attributes, {})
            end

            def documents
              list = attributes.fetch(:documents, [])
              Documents.new(list)
            end

            def time
              attributes.fetch(:time)
            end

            def results
              attributes.fetch(:results)
            end

            class Documents
              class Document
                class AttributeNotFound < StandardError; end

                attr_reader :attributes

                def initialize(document_data)
                  @attributes = document_data.fetch(:attributes, {})
                end

                def id
                  get(:id)
                end

                def get(field)
                  attributes.fetch(field.to_sym)
                rescue KeyError
                  fail AttributeNotFound, field
                end

                def score
                  get(:score)
                end
              end

              include Enumerable

              attr_reader :contents

              def initialize(raw_list = [])
                @contents = raw_list.map { |item| Document.new(item) }
              end

              def each(&block)
                contents.each(&block)
              end
            end

          end

        end
      end
    end
  end
end
