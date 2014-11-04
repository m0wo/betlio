require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'mongo'
require 'uri'

@@deck = Array.new

def buildDeck()
	cardName = ""
	
	(1..52).each do |i|
		if i % 13 === 1
			cardName = "A"
		elsif i % 13 === 10
			cardName = "T"
		elsif i % 13 === 11
			cardName = "J"
		elsif i % 13 === 12
			cardName = "Q"
		elsif i % 13 === 0
			cardName = "K"
		else
			cardName = i % 13
		end

		if i <= 13
			suit = "C"
		elsif i <= 26
			suit = "H"
		elsif i <= 39
			suit = "S"
		else
			suit = "D"
		end
		
		@@deck[i-1] = cardName.to_s + suit.to_s
	end	
end	

def deal(numCards)
	(1..numCards).each do |i|
		chosenCard = Random.rand(1..@@deck.length)
		@@hand.push(@@deck[chosenCard])
		@@deck.delete(chosenCard)
	end
end

def checkScore()
	@@hand.each do |i|
		currentCard = i
		currentValue = currentCard[0]

		if currentValue === "T" || currentValue === "J" || currentValue === "Q" || currentValue === "K"
			@@score = @@score + 10
		elsif currentValue === "A"
			@@score = @@score + 11
		else
			@@score = @@score + currentValue.to_i
		end
	end
end

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
		updateDb(@@hand, @@score, "testUser")
		twiml = Twilio::TwiML::Response.new do |r|
			r.Message "Hand: #{@@hand} Score: #{@@score}"
		end 
	end

	twiml.text
end

get '/mongoTest' do
	db = get_connection
	collections = db.collection_names
	"collections = #{collections}"		
	coll = db['test']
	coll.insert({"name" => "test"})

end
