require 'sinatra'
require 'dotenv'
require 'json'

get '/' do 
	erb :index
end