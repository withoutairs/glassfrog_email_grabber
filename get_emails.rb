require "open-uri"
require 'nokogiri'

GLASSFROG_URI = 'https://glassfrog.holacracy.org/api/v2/'

def get method
	URI.parse("#{GLASSFROG_URI}#{method}.xml?api_key=#{glassfrog_key}").read
end

def glassfrog_key
	ENV['GLASSFROG_KEY']
end

def target_circle
	ARGV.first
end

xml_circles = get("circle")
circles = Nokogiri::XML.parse(xml_circles).xpath("circles/circle")
circle_hashes = circles.map do |circle|
	{id: circle.xpath('id').text, name: circle.xpath('name').text}
end
names_to_ids = {}
circle_hashes.each { |circle| names_to_ids[circle[:name]] = circle[:id]}
	
puts names_to_ids
circle_id = names_to_ids[target_circle]
puts get "circle/#{circle_id}/mailing_list"