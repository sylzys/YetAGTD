#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'pry'
require 'json'
require 'sinatra/jsonp'
require 'dbi'
require 'sqlite3'

#DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/mytasks.sqlite3")
dbh = DBI.connect(:SQLite3, :database => ":notes:")
class Note  
  include DataMapper::Resource  
  property :id, Serial  
  property :title, Text, :lazy => false
  property :content, Text, :lazy => false
  property :created_at, DateTime  
  property :updated_at, DateTime  
end  
  
DataMapper.finalize.auto_upgrade!  

#display all notes
get '/' do 

  # case params[:tri] 
  #    when 2
  #    @notes = Note.all :order => :updated_at.desc
  #   when 3
  #     @notes = Note.all :order => :title.asc 
  #   else
  #    @notes = Note.all :order => :id.desc  
  # end 
  
  @notes = db.execute( "select * from notes ORDER BY title asc" )
#sort_order = 'title'.to_sym
# sort_obj = sort_order.asc
 #sort = DataMapper::Query::Operator.new(sort_order, sort_obj)
#  @notes=  Notes.all(:order => [sort])
 # @notes = Note.all(:order => [:title.asc]).sort_by
 	#@notes = Note.find( :all, :order => "title" )
  @title = 'My Notes'  
  binding.pry
  erb :home  
end  


# link to save note
get '/new' do  
  @notes = Note.all :order => :title.desc  
  @title = 'My Notes'  
  @create = "y"
  erb :home  
end  

#save new note
post '/' do  
  n = Note.new  
  # if params[:title].empty? 
  # 	n.title = "empty note"
  # else 
  # 	n.title = params[:title]
  # end
 n.title = params[:title].strip.empty? ? "Note sans titre" : params[:title]
  n.content = params[:content]  
  n.created_at = Time.now  
  n.updated_at = Time.now  
  n.save  
  #binding.pry
  redirect '/'  
end  

#get note in right panel
get '/:id' do  
  @title = 'My Notes' 
  @notes = Note.all :order => :title.desc  	
  @note = Note.get params[:id]  
  @id = params[:id]
  #binding.pry
  erb :home
end  

#save edited note
post '/edit' do  
  n = Note.get params[:id] 
  n.title = params[:title]
  n.content = params[:content]  
  n.updated_at = Time.now  
  n.save  
 #binding.pry
  redirect to("/")
end  
post '/delete' do  
  n = Note.get params[:id] 
  n.destroy
 #binding.pry
  redirect to("/")
end  