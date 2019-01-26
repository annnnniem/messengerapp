require 'sinatra'
require 'dotenv/load'
require 'json'
require 'intercom'

def initialize_intercom
	if @intercom.nil? then
		token = ENV['token']
		@intercom = Intercom::Client.new(token: token)
	end
end

get '/' do 
	erb :index
end

post '/' do 
	#array to hold the convos
	@github_convos = {}
	#get the user id from the field input
	@id = params[:id]
	initialize_intercom
	list_conversations(@id)
	@conversations.each do |i|
		convo = get_conversation(i)
		parts = get_parts(convo)
		check_parts_for_string(parts)
	end
	erb :issues
end

def list_conversations(id)
	@conversations = @intercom.conversations.find_all(:type => 'user', :intercom_user_id => id)
end

def get_conversation(conversation)
	@convo = @intercom.conversations.find(:id => conversation.id)
end
	
def get_parts(conversation)
	@array_of_notes = conversation.conversation_parts.reject { |part| part.part_type != 'note' && part.author != 'bot'}
end

def check_parts_for_string(parts)
	parts.each do |m|
		if m.body.include? "https://github"
			url = m.body.match(/(https?:\/\/github.com\/.+\/.+\/issues\/\d+)/)
			@github_convos.store(@convo.id, url)
		else
			break
		end
	end
end
