require 'sinatra'
require 'sinatra/jsonapi'
require 'sinatra/mongo'
require 'json'
  
set :mongo, 'mongodb://tobias:tobias@linus.mongohq.com:10038/app12523429'

venue = {
	:name => "CityArms",
	:address => "Cardiff", 
	:url => "",
	:rating => 0
}
#puts mongo["venue"].insert venue

get '/', :provides => 'html' do
   erb :index

   {:venues => mongo["venue"].find.to_a}
end

get '/venues/' do
   api_response mongo["venue"].find.to_a
end

get '/venue/:id' do
   api_response mongo["venue"].find("_id" => BSON::ObjectId(params[:id])).to_a
end

post '/venue/' do
   api_response mongo["venue"].insert JSON.parse(request.body.read.to_s)
end

put '/venue/:id' do
   mongo["venue"].update({"_id" => BSON::ObjectId(params[:id])}, JSON.parse(request.body.read.to_s))
   api_response mongo["venue"].find("_id" => BSON::ObjectId(params[:id])).to_a
end

delete '/venue/:id' do
   api_response mongo["venue"].remove("_id" => BSON::ObjectId(params[:id]))
end
