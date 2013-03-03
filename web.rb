require 'sinatra'
require 'sinatra/jsonapi'
require 'json'

helpers do
   def connection
      #TODO: Move this code elsewhere closer to the tests
      if ENV['RACK_ENV'].eql? 'test'
         require File.join(File.dirname(__FILE__), './spec/embedded-mongo/lib/embedded-mongo')
         conn = EmbeddedMongo::Connection.new
         mongo = conn['test']

         return mongo
      end   

      require 'sinatra/mongo'
      set :mongo, 'mongodb://tobias:tobias@linus.mongohq.com:10038/app12523429'
   end

   def venues
      connection['venue']
   end

   def dress(mongo_object)
      if mongo_object.respond_to?('map')
         mongo_object.map do |o|
            #TODO: Find out why this object is not fucking immutable
            new = o.clone
            new["id"] = new["_id"].to_s
            new.delete("_id")
            new
         end
      end
   end
end

get '/', :provides => 'html' do
   @venues = venues.find.to_a
   
   erb :index
end

before do 
   unless request.content_length.nil? || request.content_length.to_i < 2
      @venue = JSON.parse(request.body.read.to_s)
      @venue.delete(:id)
   end
end

get '/venues/?:id?' do |id|
   api_response dress(venues.find.to_a) if id.nil?

   api_response dress(venues.find("_id" => BSON::ObjectId(id)).to_a).first
end

post '/venues/?' do
   api_response venues.insert @venue
end

put '/venues/:id' do |id|
   venues.update({"_id" => BSON::ObjectId(id)}, @venue)

   api_response dress(venues.find("_id" => BSON::ObjectId(id)).to_a).first
end

delete '/venues/:id' do |id|
   api_response venues.remove("_id" => BSON::ObjectId(id))
end
