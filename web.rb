require 'sinatra'
require 'sinatra/jsonapi'
require 'sinatra/mongo'

set :mongo, 'mongodb://tobias:tobias@linus.mongohq.com:10038/app12523429'

venue = {
	:name => "CityArms",
	:address => "Cardiff", 
	:url => "",
	:rating => 0
}

#puts mongo["venue"].insert venue

get '/' do
   api_response mongo["venue"].find_one
end
