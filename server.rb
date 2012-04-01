#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'pry'
require 'json'
require 'sinatra/jsonp'
require 'dbi'
require 'sqlite3'
  
db =   SQLite3::Database.new( "db/mytasks.sqlite3" )
db.results_as_hash = true #result in array

#display all notes
get '/*' do 
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
post '/hello' do  
  # @notes = db.execute( "select * from notes" )
  # @title = 'My Notes'  
  # @create = "y"
 # binding.pry
 jsonp "hello"
 #erb :nopage, :layout => !request.xhr?

end  

#save new note
post '/' do  
  created_at = Time.now.to_i
  db.execute("INSERT INTO notes (title, content, created_at, updated_at) VALUES ('#{params['title'].lstrip.rstrip}', '#{params['content'].lstrip.rstrip}', #{created_at}, #{created_at})")
  redirect '/'  
end  


#save edited note
post '/edit' do  
  
 db.execute("UPDATE notes SET title=? WHERE id=?;", params[:title], params[:id]);
 db.execute("UPDATE notes SET content=? WHERE id=?;", params[:content], params[:id]);
 db.execute("UPDATE notes SET updated_at=? WHERE id=?;", params[:updated_at], params[:id]);
 #binding.pry
 redirect to("/?tri=@tri")
end  

post '/delete' do  
 
  db.execute("DELETE FROM notes WHERE id=?;", params[:id]);
  redirect to("/")
end  