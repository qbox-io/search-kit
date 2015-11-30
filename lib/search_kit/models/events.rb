module SearchKit
  module Models
    class Events
      include Enumerable

      def self.[](*arguments)
        new(arguments)
      end

      attr_reader :contents, :member_class

      def initialize(contents = [])
        @contents     = contents
        @member_class = SearchKit::Models::Event
      end

      def <<(new_event)
        case new_event
        when Hash         then contents << member_class.new(new_event)
        when member_class then contents << new_event
        else contents
        end
      end

      def each(&block)
        contents.each(&block)
      end

    end
  end
end
