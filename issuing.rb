require 'sinatra'
require 'dotenv'
require 'json'
require 'intercom'

get '/' do 
	erb :index
end

post '/' do 
	@id = params[:id]
	initialize_intercom
	get_conversations
	erb :issues
end

def initialize_intercom
	if @intercom.nil? 
		token = ENV['token']
		@intercom = Intercom::Client.new(token: token)
	end
end

def get_conversations
	@conversations = @intercom.conversations.find_all(:type => 'user', :intercom_user_id => @id)
end