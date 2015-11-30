require 'ansi'

module SearchKit
  class Messages
    # The goal of the Messaging module is to provide an easy to include internal
    # interface which will allow a SearchKit gem to dutifully log and provide
    # output of what it's up to and how it may be doing.
    #
    module Messaging
      def info(message)
        Message.new(message).info
      end

      def warning(message)
        Message.new(message).warn
      end

      def prompt(message)
        Message.new(message).prompt
      end

      def password_prompt(message)
        Message.new(message).password_prompt
      end

      private

      # Most of the logic for the Messaging module exists in this (not so)
      # private class.  This lets more complex handling of message logic enter
      # into the module gracefully, for example silence or logging level.
      #
      class Message
        attr_reader :cli, :message

        def initialize(message)
          @message = message
          @cli     = HighLine.new
        end

        def warn
          Kernel.warn(Prefixed(message.ansi(:red))) if SearchKit.config.verbose
          SearchKit.logger.warn message
        end

        def info
          Kernel.puts(Prefixed(message.ansi(:cyan))) if SearchKit.config.verbose
          SearchKit.logger.info message
        end

        def prompt
          cli.ask(Prefixed(message.ansi(:cyan)))
        end

        def password_prompt
          cli.ask(Prefixed(message.ansi(:cyan))) do |prompt|
            prompt.echo = '*'
          end
        end

        private

        def Prefixed(*messages)
          Prefixed.new.join(*messages)
        end

        class Prefixed
          attr_reader :body

          def initialize
            env   = SearchKit.config.app_env.to_s.ansi(:magenta)
            @body = "--> [ #{env} ]: "
          end

          def join(*messages)
            [body, *messages].join(" ")
          end

        end
      end

    end
  end
end
