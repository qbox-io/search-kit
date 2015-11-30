require 'ansi'
require 'highline'
require 'thor'
require 'search_kit/thor'

module SearchKit
  module CLI
    autoload :All,         'search_kit/cli/all'
    autoload :Documents,   'search_kit/cli/documents'
    autoload :Events,      'search_kit/cli/events'
    autoload :Indices,     'search_kit/cli/indices'
    autoload :Search,      'search_kit/cli/search'
    autoload :Subscribers, 'search_kit/cli/subscribers'
  end
end
