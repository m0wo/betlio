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

def updateDb(playerHand, dealerHand, user)
	db = get_connection
	coll = db['test']
	coll.insert({
		"playerHand" => hand,
		"dealerHand" => dealerHand,
		"user" => user
	})
end

def newGame(user)
	@bj = Blackjack.new
	@bj.buildDeck
	@bj.deal(2, @bj.playerHand)
	@bj.deal(1, @bj.dealerHand)
	updateDb(@bj.playerHand, @bj.dealerHand, user)

end

def hit

end

get '/' do
	updateDb("testHand", "testScore", "testUser")
	message = params[:Body]
	user = params[:From]
	
	if message == "DEAL"
		newGame(user)
	

		twiml = Twilio::TwiML::Response.new do |r|
			r.Message "Hand: #{@bj.playerHand} Score: #{@bj.playerScore}"
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
