require 'virtus'

module SearchKit
  module Models
    autoload :Document,   'search_kit/models/document'
    autoload :Documents,  'search_kit/models/documents'
    autoload :Event,      'search_kit/models/event'
    autoload :Events,     'search_kit/models/events'
    autoload :Key,        'search_kit/models/key'
    autoload :Keys,       'search_kit/models/keys'
    autoload :Search,     'search_kit/models/search'
    autoload :Subscriber, 'search_kit/models/subscriber'
  end
end
