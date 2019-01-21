require 'sinatra'
require 'dotenv/load'
require 'json'
require 'intercom'

get '/' do 
	erb :index
end

post '/' do 
	@id = params[:id]
	initialize_intercom
	@conversations = @intercom.conversations.find_all(:type => 'user', :intercom_user_id => @id)
	@conversations.each do |i|
		#get each convo
		convo = @intercom.conversations.find(:id => i.id)
		#get parts on the gotten convo
		convo_parts = convo.conversation_parts
		#look in each convo part
		@github_convos = Array.new
		convo_parts.each do |m|
			if !m.body.nil? 
				if m.body.include? "a"
					@github_convos.push(i)
				else
					break
				end
				puts @github_convos
			end
		end
	end
	erb :issues
end


def initialize_intercom
	if @intercom.nil? then
		token = ENV['token']
		@intercom = Intercom::Client.new(token: token)
	end
end