require 'sinatra'
require 'sinatra/jsonapi'
require 'sinatra/mongo'
require 'json'
  
set :mongo, 'mongodb://tobias:tobias@linus.mongohq.com:10038/app12523429'

venue = {
	:name => "CityArms",
	:address => "Cardiff", 
   :description => "",
	:url => "",
	:rating => 0
}

get '/', :provides => 'html' do
   @venues = mongo["venue"].find.to_a
   
   erb :index
end

before do 
   unless request.content_length.nil? || request.content_length.to_i < 2
      venue = JSON.parse(request.body.read.to_s)
      venue.delete(:id)
   end
end

def dress(mongo_object)
   if mongo_object.respond_to?('map')
      mongo_object.map do |o|
         o["id"] = o["_id"].to_s
         o.delete("_id")
         o
      end
   end
end

get '/venues/?:id?' do |id|
   api_response dress(mongo["venue"].find.to_a) if id.nil?

   api_response dress(mongo["venue"].find("_id" => BSON::ObjectId(id)).to_a).first
end

post '/venues/?' do
   api_response mongo["venue"].insert venue
end

put '/venues/:id' do |id|
   mongo["venue"].update({"_id" => BSON::ObjectId(id)}, venue)
   api_response dress(mongo["venue"].find("_id" => BSON::ObjectId(id)).to_a).first
end

delete '/venues/:id' do |id|
   api_response mongo["venue"].remove("_id" => BSON::ObjectId(id))
end
