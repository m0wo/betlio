require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'mongo'
require 'uri'
require 'blackjack'

def get_connection
	return @db_connection if @db_connection
	db = URI.parse(ENV['MONGOHQ_URL'])
	db_name = db.path.gsub(/^\//, '')
	@db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
	@db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
	@db_connection
end

def updateDb(hand, score, user)
	db = get_connection
	coll = db['test']
	coll.insert({
		"hand" => hand,
		"score" => score,
		"user" => user
	})
end
get '/' do
	updateDb("testHand", "testScore", "testUser")
	message = params[:Body]
	user = params[:From]
	
	if message == "DEAL"
		buildDeck()
		@@score = 0
		@@hand = Array.new	
		deal(2)
		checkScore()
		updateDb(@@hand, @@score, user)
		twiml = Twilio::TwiML::Response.new do |r|
			r.Message "Hand: #{@@hand} Score: #{@@score}"
		end 
	end

	twiml.text
end

get '/mongoTest' do
	bj = Blackjack.new
	db = get_connection
	collections = db.collection_names
	"collections = #{collections}"		
	coll = db['test']
	coll.insert({"gameObject" => bj})

end
