module SearchKit
  module Models
    class Document
      class AttributeNotFound < StandardError; end

      include Virtus.model

      attribute :id
      attribute :source
      attribute :score

      def initialize(document_data = {})
        attributes = document_data.fetch(:attributes, {})

        super(
          source: attributes,
          id:     attributes.fetch(:id, nil),
          score:  attributes.fetch(:score, nil)
        )
      end

      def get(field)
        source.fetch(field.to_sym)
      rescue KeyError
        fail AttributeNotFound, field
      end

    end
  end
end
