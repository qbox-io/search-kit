module SearchKit
  class Events
    # An extraction of the publication client action, which contains a certain
    # amount of logic in handling success/failure, parameter building and
    # API interaction.
    #
    class Publish
      SUCCESS = 202

      attr_reader :channel, :connection, :payload

      def initialize(options = {})
        @connection = options.fetch(:connection)
        @channel    = options.fetch(:channel)
        @payload    = options.fetch(:payload)
      end

      def perform
        body = JSON.parse(response.body, symbolize_names: true)

        if success?
          body
        else
          fail Errors::PublicationFailed, body.fetch(:error)
        end
      end

      private

      def success?
        response.status == SUCCESS
      end

      def response
        @response ||= connection.post("/api/events", params)
      end

      def params
        {
          type: 'events',
          data: { attributes: { channel: channel, payload: payload } }
        }
      end

    end

  end
end
