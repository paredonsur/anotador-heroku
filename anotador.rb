require 'rubygems'  
require 'sinatra'  
require 'data_mapper'

# DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/anotador.db")  
DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/anotador.db")  
class Nota  
  include DataMapper::Resource  
  property :id, Serial  
  property :content, Text, :required => true  
  property :complete, Boolean, :required => true, :default => false  
  property :created_at, DateTime  
  property :updated_at, DateTime  
end  
DataMapper.finalize.auto_upgrade! 


get '/' do  
  @notas = Nota.all :order => :id.desc  
  @title = 'Todas las Notas'  
  erb :home  
end  


post '/' do  
  n = Nota.new  
  n.content = params[:content]  
  n.created_at = Time.now  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end  


get '/:id' do  
      @nota = Nota.get params[:id]  
      @title = "Edit nota ##{params[:id]}"  
      erb :edit  
end  

put '/:id' do  
  n = Nota.get params[:id]  
  n.content = params[:content]  
  n.complete = params[:complete] ? 1 : 0  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end  

get '/:id/delete' do  
  @nota = Nota.get params[:id]  
  @title = "Confirm deletion of nota ##{params[:id]}"  
  erb :delete  
end  

delete '/:id' do  
  n = Nota.get params[:id]  
  n.destroy  
  redirect '/'  
end  

get '/:id/complete' do  
  n = Nota.get params[:id]  
  n.complete = n.complete ? 0 : 1 # flip it  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end  