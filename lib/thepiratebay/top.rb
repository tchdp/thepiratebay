require 'uri'

module ThePirateBay
  class Top
    attr_reader :torrents
    alias_method :results, :torrents

    def initialize(category = 'all')
      fetch = Fetch.new "https://thepiratebay.org/top/#{category}"
      @torrents = fetch.torrents
    end
  end
end
