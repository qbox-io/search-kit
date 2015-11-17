require 'thor'

module SearchKit
  class Search
    class CLI < Thor
      module Actions
        class Search
          def self.perform(options = {})
            new(options).perform
          end

          include Messaging

          attr_reader :client, :slug, :phrase

          def initialize(options = {})
            @client = options.fetch(:client)
            @slug   = options.fetch(:slug)
            @phrase = options.fetch(:phrase, nil)
          end

          def perform
            SearchResult.new(search_response)
          rescue Errors::IndexNotFound
            warning "No resource for `#{slug}` found"
          rescue Errors::BadRequest
            warning "Some request parameters were not supplied"
          rescue Errors::Unprocessable
            warning "Search request unprocessable"
          rescue Faraday::ConnectionFailed
            warning "No running service found"
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
