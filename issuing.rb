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
		#get each convo
		convo = @intercom.conversations.find(:id => i.id, :display_as => 'plaintext')
		#get parts on the gotten convo
		convo_parts = convo.conversation_parts
		#look in each convo part
		convo_parts.each do |m|
			if !m.body.nil? && m.part_type == "note"
				downcased_body = m.body.downcase
				#for some reason, only pasted in links from gh work, not the bot comment. potentially because not plaintext?
				if downcased_body.include? "github"
					@github_convos.store(i.id, m.body)
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