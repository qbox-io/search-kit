module SearchKit
  module Models
    class Document
      class AttributeNotFound < StandardError; end

      include Virtus.model

      attribute :id
      attribute :source
      attribute :score

      def initialize(document_data = {})
        super(
          source: document_data.fetch(:source, {}),
          id:     document_data.fetch(:id, nil),
          score:  document_data.fetch(:score, nil)
        )
      end

      def get(field)
        source.fetch(field.to_sym)
      rescue KeyError
        fail AttributeNotFound, field
      end

      def respond_to_missing?(method_name, include_private = false)
        source.has_key?(method_name) || super(method_name, include_private)
      end

      def method_missing(method_name, *arguments, &block)
        get(method_name)
      rescue AttributeNotFound
        super(method_name, *arguments, &block)
      end

    end
  end
end
