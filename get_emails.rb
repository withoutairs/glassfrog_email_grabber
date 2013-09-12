require "open-uri"
require 'nokogiri'

GLASSFROG_URI = 'https://glassfrog.holacracy.org/api/v2/'

def get method
	URI.parse("#{GLASSFROG_URI}#{method}.xml?api_key=#{glassfrog_key}").read
end

def glassfrog_key
	ENV['GLASSFROG_KEY']
end

circles = get "circle"
x = Nokogiri::XML.parse(circles).xpath("circles/circle").map do |circle|
	{id: circle.xpath('id').text, name: circle.xpath('name').text}
end

puts x