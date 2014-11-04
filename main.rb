require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

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

buildDeck()

@@hand = Array.new

def deal(numCards)
	(1..numCards).each do |i|
		chosenCard = Random.rand(1..@@deck.length)
		@@hand.push(@@deck[chosenCard])
		@@deck.delete(chosenCard)
	end
end

deal(2)
puts @@hand
@@score = 0

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
puts @@score
end
checkScore();

get '/' do
	message = params[:Body]
	if message == "DEAL"
		deal(2)
		twiml = Twilio::TwiML::Response.new do |r|
			r.Message "Hand: #{@@hand} Score: #{@@score}"
		end 
	end
#	twiml = Twilio::TwiML::Response.new do |r|
#		r.Message "#{message} to you to."
#	end
	twiml.text
end
