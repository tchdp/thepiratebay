# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'uri'

module ThePirateBay
  class Fetch
    attr_reader :torrents
    alias_method :results, :torrents

    def initialize(url)
      doc = Nokogiri::HTML(open(url))
      torrents = []

      doc.css('#searchResult tr').each do |row|
        title = row.search('.detLink').text
        next if title == ''

        seeders     = row.search('td')[2].text.to_i
        leechers    = row.search('td')[3].text.to_i
        magnet_link = row.search('td a')[3]['href']
        category    = row.search('td a')[0].text
        url         = row.search('.detLink').attribute('href').to_s
        torrent_id  = url.split('/')[2]

        desc_line   = row.search('font.detDesc').children.first.text
        size = extract_size(desc_line)

        torrent = {:title       => title,
                   :seeders     => seeders,
                   :leechers    => leechers,
                   :magnet_link => magnet_link,
                   :category    => category,
                   :torrent_id  => torrent_id,
                   :url         => url,
                   :size        => size}

        torrents.push(torrent)
      end

      @torrents = torrents
    end

    private

    def extract_size string
      match = string.match(/Size ([\d\.]+) ([GM]iB)/)
      return nil unless match.length == 3

      size = match[1].to_f
      multiplier = case match[2].downcase
                   when 'kib' then 1024
                   when 'mib' then 1048576
                   when 'gib' then 1073741824
                   when 'tib' then 1099511627776
                   else return nil
                   end
      return size * multiplier
    end
  end
end
