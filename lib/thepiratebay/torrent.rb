require 'nokogiri'
require 'open-uri'

module ThePirateBay
  class Torrent
    def self.find(torrent_id)

      doc = Nokogiri::HTML(open('http://thepiratebay.org/torrent/' + torrent_id.to_s))

      contents    = doc.search('#detailsframe')
      dd_cache    = contents.search('#details dd').select{|dd| is_a_number?(dd.text) }
      title       = contents.search('#title').text.strip
      category    = contents.search('#details .col1 dd')[0].text
      nr_files    = dd_cache[0].text
      size        = contents.search('#details .col1 dd')[2].text
      uploaded    = contents.search('#details dd').select{|dd| dd.text.include?("GMT") }[0].text
      seeders     = dd_cache[1].text
      leechers    = dd_cache[2].text
      torrent_link = contents.search('#details .download a')[0]['href'] 
      magnet_link = contents.search('#details .download a')[1]['href']
      description = contents.search('#details .nfo pre').text
      url         = 'http://thepiratebay.org/torrent/' + torrent_id.to_s
      poster_url  = 'http:' + contents.search("#details .torpicture img")[0].attributes["src"].value


      torrent = {:torrent_id  => torrent_id,
                 :title       => title,
                 :category    => category,
                 :files       => nr_files, 
                 :size        => size,
                 :uploaded    => uploaded,
                 :seeders     => seeders,
                 :leechers    => leechers,
                 :magnet_link => magnet_link,
                 :description => description,
                 :url         => url,
                 :poster_url  => poster_url,
                 :torrent_url => torrent_link}

      return torrent
    end

    def self.is_a_number?(s)
      s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
    end
  end
end
