require 'thor'
require 'search_kit/thor'

module SearchKit
  class CLI < Thor
    class Events < Thor
      autoload :Complete, 'search_kit/cli/events/complete'
      autoload :List,     'search_kit/cli/events/list'
      autoload :Pending,  'search_kit/cli/events/pending'
      autoload :Publish,  'search_kit/cli/events/publish'
      autoload :Status,   'search_kit/cli/events/status'

      namespace :events

      document :complete
      def complete(id)
        Complete.new(client, id).perform
      end

      document :pending
      option :channel, aliases: ['-c']
      def pending
        channel = options.fetch('channel', nil)
        if channel
          Pending.new(client, channel).perform
        else
          List.new(client).perform
        end
      end

      document :publish
      option :payload, aliases: ['-p'], type: :hash, required: true
      def publish(channel)
        Publish.new(client, channel, options).perform
      end

      document :status
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
