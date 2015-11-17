require 'thor'

module SearchKit
  class CLI < Thor
    include Messaging

    desc "documents", "Manage individual SearchKit documents"
    subcommand "documents", SearchKit::Documents::CLI

    desc "events", "Publish and subscribe to SearchKit events"
    subcommand "events", SearchKit::Events::CLI

    desc "indices", "Manage your SearchKit indices"
    subcommand "indices", SearchKit::Indices::CLI

    desc "search", "Quickly search your indices"
    subcommand "search", SearchKit::Search::CLI

    desc "config SETTING [VALUE]", "Configure or view your SearchKit settings"
    def config(setting, value = nil)
      if value
        SearchKit.set_config(setting, value)
        info "Set #{setting}: #{value}"
      else
        value = SearchKit.show_config(setting)
        info "SearchKit settings for #{setting}:"
        info " - ~/.search-kit/config.yml: #{value}"
        info " - ENV: #{ENV.fetch(setting.upcase, "Not set")}"
        info " - Runtime: #{SearchKit.config.send(setting)}"
      end
    end
  end
end
