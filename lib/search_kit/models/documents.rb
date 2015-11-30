module SearchKit
  module Models
    class Documents
      include Enumerable

      def self.[](*arguments)
        new(arguments)
      end

      attr_reader :contents, :member_class

      def initialize(contents = [])
        @contents     = contents
        @member_class = SearchKit::Models::Document
      end

      def <<(new_doc)
        case new_doc
        when Hash         then contents << member_class.new(new_doc)
        when member_class then contents << new_doc
        else contents
        end
      end

      def each(&block)
        contents.each(&block)
      end

    end
  end
end
