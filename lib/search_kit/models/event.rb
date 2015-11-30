module SearchKit
  module Models
    class Event
      include Virtus.model

      attribute :id
      attribute :channel
      attribute :state
      attribute :payload, Hash

      def initialize(event_data = {})
        attributes = event_data.fetch(:attributes, {})
        super(attributes)
      end

    end
  end
end
