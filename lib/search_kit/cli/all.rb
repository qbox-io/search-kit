require 'ansi'
require 'faraday'
require 'highline'
require 'json'
require 'search_kit/thor'
require 'thor'

module SearchKit
  module CLI
    class All < Thor
      no_commands do
        def messages
          @messages ||= Messages.new
        end
      end

      desc "documents", "Manage individual SearchKit documents"
      subcommand "documents", SearchKit::CLI::Documents

      desc "events", "Publish and subscribe to SearchKit events"
      subcommand "events", SearchKit::CLI::Events

      desc "indices", "Manage your SearchKit indices"
      subcommand "indices", SearchKit::CLI::Indices

      desc "scaffolds", "Build and populate an index in one command"
      subcommand "scaffolds", SearchKit::CLI::Scaffolds

      desc "search", "Quickly search your indices"
      subcommand "search", SearchKit::CLI::Search

      desc "subscribers", "Register and control a subscriber account"
      subcommand "subscribers", SearchKit::CLI::Subscribers

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

      desc "setup", "Set up your search-kit environment"
      def setup
        messages.info("Setting up a new SearchKit account")
        messages.info("")

        email      = messages.prompt("Email: ")
        password   = messages.password_prompt("Password: ")
        client     = SearchKit::Clients::Subscribers.new
        subscriber = client.create(email: email, password: password)

        config("app_token", subscriber.creator_tokens.first)
        messages.info("Alright!  Your search-kit install has been set up.")
      rescue Errors::Unprocessable
        messages.unprocessable
      end
    end
  end
end
