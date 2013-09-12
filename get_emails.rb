require "open-uri"
require 'nokogiri'

def get method
	URI.parse("#{glassfrog_uri}#{method}.xml?api_key=#{glassfrog_key}").read
end

def glassfrog_uri; 'https://glassfrog.holacracy.org/api/v2/'; end
def glassfrog_key; ENV['GLASSFROG_KEY']; end
def target_circle; ARGV.first; end

circles_xml = get("circle")
circles = Nokogiri::XML.parse(circles_xml).xpath("circles/circle")
circle_hashes = circles.map do |circle|
	{id: circle.xpath('id').text, name: circle.xpath('short-name').text}
end
names_to_ids = {}
circle_hashes.each { |circle| names_to_ids[circle[:name]] = circle[:id]}

if (target_circle) 
	circle_id = names_to_ids[target_circle]
	circle_xml = get "circle/#{circle_id}/mailing_list"
	people = Nokogiri::XML.parse(circle_xml).xpath("people/person/email")
	puts people.map {|person| "#{person.text}"}
else
	puts "please specify a circle from the below:"
	puts circle_hashes.map {|circle| circle[:name]}
end