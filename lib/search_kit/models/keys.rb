module SearchKit
  module Models
    class Keys < Array
      def creator
        reduce(self.class.new) do |keys, key|
          keys << key if key.creator?
          keys
        end
      end

      def tokens
        map(&:token)
      end
    end
  end
end
