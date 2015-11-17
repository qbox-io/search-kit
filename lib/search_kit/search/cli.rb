require 'thor'

module SearchKit
  class Search
    class CLI < Thor
      autoload :Actions, 'search_kit/search/cli/actions'

      include Messaging

      namespace :search

      desc "search SLUG PHRASE", "Search an index".ansi(:cyan, :bold)
      option :filters, aliases: ['-f'], type: :hash, required: false
      option :display, aliases: ['-d'], type: :array, required: false
      def search(slug, phrase)
        search = Actions::Search.perform(
          client: client,
          phrase: phrase,
          slug:   slug
        )

        info "Searching `#{slug}` for titles matching `#{phrase}`:"
        info " - Found #{search.results} titles in #{search.time}ms"

        display = options.fetch('display', [])

        search.documents.each do |document|
          if display.any?
            fields = display.map { |field| document.get(field) }
            info " -- #{fields.join(' | ')} | score: #{document.score}"
          else
            info " -- #{document.id} | score: #{document.score}"
          end
        end
      end

      no_commands do
        alias_method :s, :search
      end

      private

      def client
        @client ||= Client.new
      end

    end
  end
end
