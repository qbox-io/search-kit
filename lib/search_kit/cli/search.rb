require 'thor'
require 'search_kit/thor'

module SearchKit
  class CLI < Thor
    class Search < Thor
      namespace :search

      no_commands do
        def client
          @client ||= Search.new
        end

        def messages
          @messages ||= Messages.new
        end
      end

      document :create
      option :display, aliases: ['-d'], type: :array, required: false
      def create(slug, phrase)
        search    = client.search(slug, phrase: phrase)
        head_path = 'cli.search.create.success.headline'
        info_path = 'cli.search.create.success.info'
        headline  = I18n.t(head_path, slug: slug, phrase: phrase)
        info      = I18n.t(info_path, count: search.results, time: search.time)
        lines     = [ headline, info ]
        display   = options.fetch('display', [])

        lines += search.documents.map do |document|
          if display.any?
            fields = display.map { |field| document.get(field) }
            " -- #{fields.join(' | ')} | score: #{document.score}"
          else
            " -- #{document.id} | score: #{document.score}"
          end
        end

        lines.each(&messages.method(:info))
      rescue Errors::Unauthorized
        messages.unauthorized
      rescue Errors::IndexNotFound
        messages.not_found
      rescue Errors::BadRequest
        messages.bad_request
      rescue Errors::Unprocessable
        messages.unprocessable
      rescue Faraday::ConnectionFailed
        messages.no_service
      end

      no_commands do
        alias_method :search, :create
        alias_method :c, :create
        alias_method :s, :search
      end

    end
  end
end
