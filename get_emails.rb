require "open-uri"

GLASSFROG_URI = 'https://glassfrog.holacracy.org/api/v2/'

def get method
	URI.parse("#{GLASSFROG_URI}#{method}.xml?api_key=#{glassfrog_key}").read
end

def glassfrog_key
	ENV['GLASSFROG_KEY']
end

circles = get "circle"
puts circles