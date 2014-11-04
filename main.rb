require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

get '/' do
	message = params[:Body]
	#if message == START & zork not running
	#start zork
	twiml = Twilio::TwiML::Response.new do |r|
		r.Message "#{message} to you to."
	end
	twiml.text
end
