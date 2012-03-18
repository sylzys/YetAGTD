#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'pry'
require 'json'
require 'sinatra/jsonp'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/mytasks.sqlite3")

class Note  
  include DataMapper::Resource  
  property :id, Serial  
  property :title, Text 
  property :content, Text
  property :created_at, DateTime  
  property :updated_at, DateTime  
end  
  
DataMapper.finalize.auto_upgrade!  

#display all notes
get '/' do  
  @notes = Note.all :order => :id.desc  
  @title = 'My Notes'  
  #binding.pry
  erb :home  
end  

#save new note
post '/' do  
  n = Note.new  
  n.title = params[:title]
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
  @notes = Note.all :order => :id.desc  	
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