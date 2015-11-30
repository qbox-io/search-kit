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

    end
  end
end
