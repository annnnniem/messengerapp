require 'sinatra'
require 'dotenv/load'
require 'json'
require 'intercom'

get '/' do 
	erb :index
end

post '/' do 
	#array to hold the convos
	@github_convos = []
	#get the user id from the field input
	@id = params[:id]
	initialize_intercom
	@conversations = @intercom.conversations.find_all(:type => 'user', :intercom_user_id => @id)
	@conversations.each do |i|
		#get each convo
		convo = @intercom.conversations.find(:id => i.id)
		#get parts on the gotten convo
		convo_parts = convo.conversation_parts
		#look in each convo part
		convo_parts.each do |m|
			if !m.body.nil? 
				if m.body.include? "github"
					puts m.body
					@github_convos << m.body
				else
					break
				end
			end
		end
	end
	puts @github_convos
	erb :issues
end


def initialize_intercom
	if @intercom.nil? then
		token = ENV['token']
		@intercom = Intercom::Client.new(token: token)
	end
end