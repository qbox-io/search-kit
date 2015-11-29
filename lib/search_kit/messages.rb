require 'ansi'

module SearchKit
  class Messages
    autoload :Messaging, 'search_kit/messages/messaging'

    include Messaging

    def bad_request
      warning(I18n.t('http.400'))
    end

    def not_found(type = 'Resource')
      message = I18n.t('http.404', type: type)
      warning(message)
    end

    def json_parse_error(type = 'Argument')
      message = I18n.t('cli.errors.json_parse', type: type)
      warning(message)
    end

    def no_service
      message = I18n.t('cli.errors.no_service', uri: SearchKit.config.app_uri)
      warning(message)
    end

    def unprocessable
      warning(I18n.t('http.422'))
    end

    def unreadable(error)
      warning(I18n.t('cli.errors.unreadable', error: error))
    end

  end
end
