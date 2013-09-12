require "open-uri"
require 'nokogiri'

def get method
	URI.parse("#{glassfrog_uri}#{method}.xml?api_key=#{glassfrog_key}").read
end

def get_emails circle_xml
	emails = Nokogiri::XML.parse(circle_xml).xpath("people/person/email")
	emails.map {|email| "#{email.text}"}
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

case target_circle
when "Facilitators"
	puts get_emails get "facilitators"
when "Lead Links"
	puts get_emails get "lead_links"
when "Secretaries"
	puts get_emails get "secretaries"
when "Rep Links"
	puts get_emails get "rep_links"
when String
	circle_id = names_to_ids[target_circle]
	puts get_emails get "circle/#{circle_id}/mailing_list"
else
	puts "please specify a circle from the below:"
	puts circle_hashes.map {|circle| circle[:name]}
end