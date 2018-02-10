require 'open-uri'
require 'nokogiri'

class Speedtrap
  def self.fetchlive
  	address = Nokogiri::HTML(open("http://tanel.jairus.ee/kiiruskaamerad.html"))
  	javascript = address.css('script').text.split("locations =")[1].split("var map")[0].gsub("\n", "")
  	elements = javascript.scan(/\[\'(.*?)\'\]/)

  	speedtraps = []

  	elements.each do |speedtrap|
  		data_gibberish = speedtrap.first
  		data = data_gibberish.split(", ")

  		cam = Hash.new
  		cam["name"] = data[0].gsub("'", "")
  		cam["road"] = data[5].gsub("'", "")
  		cam["direction"] = data[4].gsub("'", "")
  		cam["latitude"] = data[1].gsub("'", "")
  		cam["longitude"] = data[2].gsub("'", "")
  		cam["limit"] = data[3].gsub("'", "")

  		speedtraps.push(cam)
  	end
  	return speedtraps
  end

end
