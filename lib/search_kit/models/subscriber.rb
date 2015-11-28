require 'virtus'

module SearchKit
  module Models
    class Subscriber
      include Virtus.model

      attribute :email, String
      attribute :id,    String
      attribute :keys,  SearchKit::Models::Keys[SearchKit::Models::Key]
      attribute :uri,   String

      def initialize(subscriber_data = {})
        attributes = subscriber_data.fetch(:attributes, {})
        keys       = subscriber_data.fetch(:relationships, {}).fetch(:keys, [])
        uri        = subscriber_data.fetch(:links, {}).fetch(:self, '')

        super(attributes.merge(uri: uri, keys: keys))
      end

      def creator_tokens
        keys.creator.tokens
      end
    end
  end
end
