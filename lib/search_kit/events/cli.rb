require 'thor'
require 'ansi'

module SearchKit
  class Events
    class CLI < Thor
      autoload :Complete, 'search_kit/events/cli/complete'
      autoload :List,     'search_kit/events/cli/list'
      autoload :Pending,  'search_kit/events/cli/pending'
      autoload :Publish,  'search_kit/events/cli/publish'
      autoload :Status,   'search_kit/events/cli/status'

      include Messaging

      namespace :events

      desc "complete ID", "Complete event for a given ID"
      def complete(id)
        Complete.new(client, id).perform
      end

      desc "pending", "Get all pending events, --channel to filter by channel"
      option :channel, aliases: ['-c']
      def pending
        channel = options.fetch('channel', nil)
        if channel
          Pending.new(client, channel).perform
        else
          List.new(client).perform
        end
      end

      desc "publish CHANNEL", "Publish an event to CHANNEL"
      option :payload, aliases: ['-p'], type: :hash, required: true
      def publish(channel)
        Publish.new(client, channel, options).perform
      end

      desc "status ID", "Check status of a specific event ID"
      def status(id)
        Status.new(client, id).perform
      end

      private

      def client
        @client ||= Events.new
      end

    end
  end
end
