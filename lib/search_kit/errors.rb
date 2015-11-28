module SearchKit
  module Errors
    class BadRequest < StandardError; end
    class EventNotFound < StandardError; end
    class IndexNotFound < StandardError; end
    class KeyNotFound < StandardError; end
    class PublicationFailed < StandardError; end
    class SubscriberNotFound < StandardError; end
    class Unauthorized < StandardError; end
    class Unprocessable < StandardError; end
  end
end
