#!/usr/bin/env ruby
require 'sinatra'
require "sinatra/jsonp"

# museums = [
#   "The Louvre",
#   "The Butler Institute",
#   "Doria Pamphilj"
# ]

# get '/museums' do
#   JSONP museums
# end
require 'sqlite3'

db =   SQLite3::Database.new( "data.db" )
    res = db.execute( "select * from notes order by title desc" )
 
res.each do |note| 
 	p note

end