module SearchKit
  module Models
    class Search
      include Virtus.model

      attribute :time
      attribute :results
      attribute :documents, Models::Documents[Models::Document]

      def initialize(search_data = {})
        attributes = search_data.fetch(:attributes, {})
        super attributes
      end

    end
  end
end
