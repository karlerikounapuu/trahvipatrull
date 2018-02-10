require 'open-uri'
require 'nokogiri'

class Speedtrap
  include Mongoid::Document

  field :name, type: String
  field :road, type: String
  field :direction, type: String
  field :limit, type: Integer

  field :latitude, type: Float
  field :longitude, type: Float

  def self.fetchlive(preserve = false)
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

      if preserve
        begin
          unless self.where(latitude: cam["latitude"], longitude: cam["longitude"]).exists?
            puts "Adding '#{cam["name"]}' to database"
            self.create(name: cam["name"],
                        road: cam["road"],
                        direction: cam["direction"],
                        limit: cam["limit"],
                        latitude: cam["latitude"],
                        longitude: cam["longitude"])
          end
        rescue StandardError
          puts "Could not add speedtrap to database."
        end
      end
  	end
  	return speedtraps
  end

end
