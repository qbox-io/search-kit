require 'thor'
require 'search_kit/thor'

module SearchKit
  class CLI < Thor
    class Search < Thor
      autoload :Actions, 'search_kit/cli/search/actions'

      namespace :search

      document :create
      option :filters, aliases: ['-f'], type: :hash, required: false
      option :display, aliases: ['-d'], type: :array, required: false
      def create(slug, phrase)
        search = Actions::Search.perform(
          client: client,
          phrase: phrase,
          slug:   slug
        )

        headline = I18n.t('cli.search.create.success.headline',
          slug: slug,
          phrase: phrase
        )

        info = I18n.t('cli.search.create.success.info',
          count: search.results,
          time:  search.time
        )

        [ headline, info ].each(&messages.method(&:info))

        display = options.fetch('display', [])

        search.documents.each do |document|
          if display.any?
            fields = display.map { |field| document.get(field) }
            messages.info " -- #{fields.join(' | ')} | score: #{document.score}"
          else
            messages.info " -- #{document.id} | score: #{document.score}"
          end
        end
      end

      no_commands do
        alias_method :search, :create
        alias_method :c, :create
        alias_method :s, :search
      end

      private

      def client
        @client ||= Search.new
      end

      def messages
        @messages ||= Messages.new
      end

    end
  end
end
