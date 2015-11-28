require 'virtus'

module SearchKit
  module Models
    class Key
      include Virtus.model

      attribute :id,        String
      attribute :name,      String
      attribute :privilege, String
      attribute :token,     String
      attribute :uri,       String

      def initialize(key_data = {})
        attributes = key_data.fetch(:attributes, {})
        uri        = key_data.fetch(:links, {}).fetch(:self, '')

        super(attributes.merge(uri: uri))
      end

      def creator?
        privilege == 'creator'
      end
    end
  end
end
