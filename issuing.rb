require 'sinatra'
require 'dotenv/load'
require 'json'
require 'intercom'

get '/' do 
	erb :index
end

post '/' do 
	#array to hold the convos
	@github_convos = {}
	#get the user id from the field input
	@id = params[:id]
	initialize_intercom
	@conversations = @intercom.conversations.find_all(:type => 'user', :intercom_user_id => @id)
	@conversations.each do |i|
		get_conversation(i)
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

def get_conversation(conversation)
	#get each convo
	@convo = @intercom.conversations.find(:id => conversation.id)
	#look in each convo part
	#array_of_notes = @convo.conversation_parts.reject { |part| part.part_type != 'note'}
	@convo.conversation_parts.each do |m| #can i do the opposite--reject it unless conditions match and THEN look at the part (.reject method)
		if !m.body.nil? && m.part_type == "note"
			downcased_body = m.body.downcase
			if downcased_body.include? "https://github"
				@github_convos.store(conversation.id, m.body) #Q for joel: how do I access these items in this array in my erb? 
			else
				break
			end
		end
	end
end