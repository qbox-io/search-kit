module SearchKit
  # This file houses the polling loop of the Event service.
  #
  class Polling
    autoload :Process, 'search_kit/polling/process'

    def self.perform(channel, &block)
      new(channel, &block).perform
    end

    attr_reader :block, :channel

    def initialize(channel, &block)
      @block   = block
      @channel = channel
    end

    def perform
      loop do
        process_queue
        sleep 1
      end
    end

    def process_queue
      SearchKit::Polling::Process.perform(channel, &block)
    end

  end
end
