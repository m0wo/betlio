require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'mongo'
require 'uri'
require_relative 'blackjack'

def get_connection
	return @db_connection if @db_connection
	db = URI.parse(ENV['MONGOHQ_URL'])
	db_name = db.path.gsub(/^\//, '')
	@db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
	@db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
	@db_connection
end

def updateDb(playerHand, dealerHand, deck, user)
	db = get_connection
	coll = db['test']
	coll.insert(
		"playerHand" => playerHand,
		"dealerHand" => dealerHand,
		"deck" => deck,
		"user" => user
	)
end

def getGameState(user)
	db = get_connection
	coll = db['test']
	user = coll.find("user" => user).to_a
	return user
	
end

def clearUser(user)
	db = get_connection
	coll = db['test']
	coll.remove("user" => user)

end

def newGame(user)
	clearUser(user)
	bj = Blackjack.new
	updateDb(bj.playerHand, bj.dealerHand, bj.deck, user)
end

def hit

end

get '/' do
	message = params[:Body]
	user = params[:From]
	
	if message == "DEAL"
		newGame(user)
		test = getGameState(user)
		twiml = Twilio::TwiML::Response.new do |r|
			r.Message test
		end 

		twiml.text
	end

end

get '/mongoTest' do
	bj = Blackjack.new
	db = get_connection
	collections = db.collection_names
	"collections = #{collections}"		
	coll = db['test']
	coll.insert({"playerHand" => bj.playerHand})
end
