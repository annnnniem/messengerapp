require 'sinatra'
require 'dotenv/load'
require 'json'

get '/' do
end

post '/initialize' do 
	#create the canvas
end


def createCanvas 
	canvas = "{
	  canvas: {
	    content: {
	      components: [
	        {
	        {type: 'text'
	         text: 'Do you like plants?'}
	          {
			  type:  'button',
			  id: 'button-123',
			  label: 'Yes',
			  action: {
			    type: 'url',
			    url: 'https://stormy-brook-67859.herokuapp.com/'
			  }
			}
	        }
	      ]
	    }
	  }
	}"
	canvas
end