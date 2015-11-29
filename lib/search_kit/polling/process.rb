module SearchKit
  class Polling
    # The logic of interacting with the event service to retrieve and process
    # events is contained here.
    #
    class Process
      def self.perform(channel, &block)
        new(channel, &block).perform
      end

      attr_reader :block, :channel, :client

      def initialize(channel, &block)
        @block   = block
        @channel = channel
        @client  = SearchKit::Clients::Events.new
      end

      def perform
        events.each do |event|
          begin
            block.call(event)
          rescue
            raise
          else
            client.complete(event.id)
          end
        end
      end

      private

      def events
        response = client.pending(channel)
        response.fetch(:data, []).map { |raw| OpenStruct.new(raw) }
      end
    end

  end
end
