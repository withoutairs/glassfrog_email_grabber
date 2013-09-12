require "open-uri"

GLASSFROG_URI = 'https://glassfrog.holacracy.org/api/v2/'

# circle_id = GLASSFROG_URI
xml = URI.parse("#{GLASSFROG_URI}person.xml?api_key=#{ENV['GLASSFROG_KEY']}").read

puts xml