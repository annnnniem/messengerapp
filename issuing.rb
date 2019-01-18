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
	list_conversations
	get_each_convo_and_check_for_gh
	erb :issues
end


def initialize_intercom
	if @intercom.nil? then
		token = ENV['token']
		@intercom = Intercom::Client.new(token: token)
	end
end

def list_conversations
	@conversations = @intercom.conversations.find_all(:type => 'user', :intercom_user_id => @id)
end

def get_each_convo_and_check_for_gh
	@conversations.each do |convo|
		@intercom.conversations.find(:id => convo.id)
		@conversation_text = convo["data"]["item"]["conversation_message"]["body"]
		@github_convos = []
		if @conversation_text.include? "https://github.com"
			@github_convos << convo
		end
			
	end

end

#something is wrong with the array but i can't figure it out rn