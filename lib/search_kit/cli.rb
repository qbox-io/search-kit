require 'thor'

module SearchKit
  class CLI < Thor
    desc "documents", "Manage individual SearchKit documents"
    subcommand "documents", SearchKit::Documents::CLI

    desc "events", "Publish and subscribe to SearchKit events"
    subcommand "events", SearchKit::Events::CLI

    desc "indices", "Manage your SearchKit indices"
    subcommand "indices", SearchKit::Indices::CLI

    desc "search", "Quickly search your indices"
    subcommand "search", SearchKit::Search::CLI

    desc "config", "Configure your SearchKit settings"
    def config
    end
  end
end
