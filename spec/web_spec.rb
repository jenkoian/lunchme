require 'web'
require 'rspec'
require 'rack/test'
require 'json'
require "json_spec"

test_venue = {
   :name => "Brandybucks",
   :address => "Bree",
   :rating => 2
}

ENV['RACK_ENV'] = 'test'

describe 'Venues API' do
   include Rack::Test::Methods

   def app
       Sinatra::Application
   end

   it "can save a venue" do
      post '/venues', test_venue.to_json

      last_response.should be_ok
      last_response.body.should have_json_path '$oid'
      last_response.body.should have_json_type(String).at_path '$oid'
      
      # Setting the unique id on the tested entity
      test_venue[:id] = JSON.parse(last_response.body)['$oid']
   end

   it "can retrieve all venues" do
      get '/venues'

      last_response.should be_ok
      last_response.body.should have_json_size 1
      last_response.body.should include_json(test_venue.to_json)   
   end

   it "can retrieve a venue" do
      get "/venues/#{test_venue[:id]}"

      last_response.should be_ok
      last_response.body.should be_json_eql(test_venue.to_json)
   end

   it "can alter a venue" do
      test_venue[:url] = "www.example.com"
      put "/venues/#{test_venue[:id]}", test_venue.to_json

      last_response.should be_ok
      last_response.body.should include("www.example.com")
   end

   it "can delete a venue" do
      delete "/venues/#{test_venue[:id]}"

      last_response.should be_ok

      get '/venues'

      last_response.should be_ok
      last_response.body.should have_json_size 0
   end
end
