#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
#require 'dm-migrations/adapters/dm-sqlite-adapter'
require 'json'
# include Mongo
# puts __FILE__
puts File.expand_path("..", __FILE__)
puts "sqlite3://#{File.join(File.dirname(__FILE__), 'db', 'db.sqlite3')}"
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do  
  @notes = Note.all :order => :id.desc  
  @title = 'All Notes'  
  erb :home 
end  

post '/' do  
  n = Note.new  
  n.content = params[:content]  
  n.created_at = Time.now  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end  