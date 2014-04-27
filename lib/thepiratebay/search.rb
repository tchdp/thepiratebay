require 'nokogiri'
require 'open-uri'
require 'uri'

module ThePirateBay
  
   class Search
    attr_reader :torrents
    alias_method :results, :torrents

    def initialize(query, page = 0, sort_by = 99, category = 0)

      query = URI.escape(query)
      full_url = "http://thepiratebay.org/search/#{query}/#{page.to_s}/#{sort_by.to_s}/#{category.to_s}"
      doc = Nokogiri::HTML(open(full_url))
      
      @torrents = ThePirateBay.get_torrents_from_doc doc
    end
  end

  class Browse
    attr_reader :torrents
    alias_method :results, :torrents

    def initialize(page = 0, sort_by = 99, category = 0)
      full_url = "http://thepiratebay.org/browse/#{category.to_s}/#{page.to_s}/#{sort_by.to_s}"
      doc = Nokogiri::HTML(open(full_url))
      
      @torrents = ThePirateBay.get_torrents_from_doc doc
    end
  end

  def self.get_torrents_from_doc(html_doc)
    torrents = []
    html_doc.css('#searchResult tr').each do |row|
      title = row.search('.detLink').text
      next if title == ''

      seeders     = row.search('td')[2].text.to_i
      leechers    = row.search('td')[3].text.to_i
      magnet_link = row.search('td a')[3]['href']
      category    = row.search('td a')[0].text
      url         = row.search('.detLink').attribute('href').to_s
      torrent_id  = url.split('/')[2]

      torrent = {:title       => title,
       :seeders     => seeders,
       :leechers    => leechers,
       :magnet_link => magnet_link,
       :category    => category,
       :torrent_id  => torrent_id,
       :url         => url}

       torrents.push(torrent)
     end
     torrents
   end
end
