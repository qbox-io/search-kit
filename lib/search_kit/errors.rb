module SearchKit
  module Errors
    class BadRequest < StandardError; end
    class IndexNotFound < StandardError; end
    class PublicationFailed < StandardError; end
    class EventNotFound < StandardError; end
    class Unprocessable < StandardError; end
  end
end
