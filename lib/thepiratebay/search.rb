require 'uri'

module ThePirateBay
  
   class Search
    attr_reader :torrents
    alias_method :results, :torrents

    def initialize(query, page = 0, sort_by = 99, category = 0)
      query = URI.escape(query)
      fetch = Fetch.new 'https://thepiratebay.org/search/' + query + '/' + page.to_s + '/' + sort_by.to_s + '/' + category.to_s + ''
      @torrents = fetch.torrents
    end
  end

  
end
