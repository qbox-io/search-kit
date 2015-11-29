require 'thor'
require 'search_kit/thor'

module SearchKit
  class CLI < Thor
    autoload :Documents, 'search_kit/cli/documents'
    autoload :Events,    'search_kit/cli/events'
    autoload :Indices,   'search_kit/cli/indices'
    autoload :Search,    'search_kit/cli/search'

    desc "documents", "Manage individual SearchKit documents"
    subcommand "documents", SearchKit::CLI::Documents

    desc "events", "Publish and subscribe to SearchKit events"
    subcommand "events", SearchKit::CLI::Events

    desc "indices", "Manage your SearchKit indices"
    subcommand "indices", SearchKit::CLI::Indices

    desc "search", "Quickly search your indices"
    subcommand "search", SearchKit::CLI::Search

    desc "config SETTING [VALUE]", "Configure or view your SearchKit settings"
    def config(setting, value = nil)
      if value
        SearchKit.set_config(setting, value)
        messages.info "Set #{setting}: #{value}"
      else
        value = SearchKit.show_config(setting)
        messages.info "SearchKit settings for #{setting}:"
        messages.info " - ~/.search-kit/config.yml: #{value}"
        messages.info " - ENV: #{ENV.fetch(setting.upcase, "Not set")}"
        messages.info " - Runtime: #{SearchKit.config.send(setting)}"
      end
    end

    private

    def messages
      @messages ||= Messages.new
    end
  end
end
