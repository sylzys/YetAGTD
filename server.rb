#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
#require 'data_mapper'
require 'dm-core'
require 'pry'
require 'json'
require 'sinatra/jsonp'
require 'dbi'
require 'sqlite3'

#DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/mytasks.sqlite3")
# dbh = DBI.connect(:SQLite3, :database => ":notes:")
# class Note  
#   include DataMapper::Resource  
#   property :id, Serial  
#   property :title, Text, :lazy => false
#   property :content, Text, :lazy => false
#   property :created_at, DateTime  
#   property :updated_at, DateTime  
# end  
  
#DataMapper.finalize.auto_upgrade!  
db =   SQLite3::Database.new( "db/mytasks.sqlite3" )
db.results_as_hash = true
#display all notes
get '/' do 
  @tri = params[:tri].to_i
  case params[:tri].to_i
     when 2
    order = " order by updated_at desc"
    when 3
     order = " order by title asc"
    else
     order = " order by id desc" 
  end 
  if (params[:id] != nil && !params[:id].empty?)
   @id = params[:id]
   where = " where id = '#{@id}'"
  else 
    id = db.get_first_value("select * from notes #{order}")
    where = " where id = '#{id}'"
end
  all = "select * from notes #{order}"
  display = "select * from notes #{where}"
  @notes = db.execute(all)
  @one_note = db.execute(display)
  @title = 'My Notes'  
  #binding.pry
  erb :home  
end  


# link to save note
get '/new' do  
  @notes = db.execute( "select * from notes" )
  @title = 'My Notes'  
  @create = "y"
 # binding.pry
  erb :home  
end  

#save new note
post '/' do  
 #  n = Note.new  
 # n.title = params[:title].strip.empty? ? "Note sans titre" : params[:title]
 #  n.content = params[:content]  
  created_at = Time.now.to_i
 #  n.updated_at = Time.now  
 #  n.save  
 #binding.pry
# db.execute("INSERT INTO notes (title, content, created_at, updated_at) VALUES ('#{params['title']}', '#{params['title']}', #{created_at}, #{created_at})")
  db.execute("INSERT INTO notes (title, content, created_at, updated_at) VALUES ('#{params['title'].lstrip.rstrip}', '#{params['content'].lstrip.rstrip}', #{created_at}, #{created_at})")
  redirect '/'  
end  

#get note in right panel
# get '/:id' do  
#   @title = 'My Notes' 
#   @note = db.execute( "select * from notes where id=#{params[:id]}" )	
#   #@note = Note.get params[:id]  
#   @id = params[:id]
#   binding.pry
#   erb :home
# end  

#save edited note
post '/edit' do  
  # n = Note.get params[:id] 
  # n.title = params[:title]
  # n.content = params[:content]  
  # n.updated_at = Time.now  
  # n.save  
 db.execute("UPDATE notes SET title=? WHERE id=?;", params[:title], params[:id]);
 db.execute("UPDATE notes SET content=? WHERE id=?;", params[:content], params[:id]);
 db.execute("UPDATE notes SET updated_at=? WHERE id=?;", params[:updated_at], params[:id]);
 #binding.pry
 redirect to("/?tri=@tri")
end  

post '/delete' do  
  # n = Note.get params[:id] 
  # n.destroy
 #binding.pry
  db.execute("DELETE FROM notes WHERE id=?;", params[:id]);
  redirect to("/")
end  