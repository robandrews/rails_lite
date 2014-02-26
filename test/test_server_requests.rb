require 'addressable/uri'
require 'rest-client'

location_query = Addressable::URI.new(
:scheme => "https",
:host => "maps.googleapis.com",
:path => "/maps/api/geocode/json",
:query_values =>{:address => location,
:sensor => false,
:key => "AIzaSyD3A-6TzsbvgjXdFswci2J6G2jDt6AEO7s"
}
).to_s