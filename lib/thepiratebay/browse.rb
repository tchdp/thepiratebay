module ThePirateBay
	class Browse
		attr_reader :torrents
		alias_method :results, :torrents

		def initialize(page = 0, sort_by = 99, category = 0)
			fetch = Fetch.new "https://thepiratebay.se/browse/#{category.to_s}/#{page.to_s}/#{sort_by.to_s}"
			@torrents = fetch.torrents
		end
	end
end