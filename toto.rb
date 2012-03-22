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
@db =   SQLite3::Database.new( "data.db" )
@db.results_as_hash = true
 # rows = db.execute( "select * from notes order by id" )
 # p rows[0].fields
 #  p rows[0].types
get '/' do
case params[:tri]
	when 1
		order = "title asc"
	else
		order= "id asc"
	end
 @res = @db.execute( "select * from notes order by #{order}" )
 
erb :index
end