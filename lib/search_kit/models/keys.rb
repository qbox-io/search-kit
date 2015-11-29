module SearchKit
  module Models
    class Keys
      include Enumerable

      def self.[](*arguments)
        new(arguments)
      end

      attr_reader :contents, :member_class

      def initialize(contents = [])
        @contents     = contents
        @member_class = SearchKit::Models::Key
      end

      def <<(new_key)
        case new_key
        when Hash         then contents << member_class.new(new_key)
        when member_class then contents << new_key
        else contents
        end
      end

      def each(&block)
        contents.each(&block)
      end

      def creator
        self.class.new(select(&:creator?))
      end

      def tokens
        contents.map(&:token)
      end
    end
  end
end
