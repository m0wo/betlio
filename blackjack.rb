class Blackjack

def initialize(*args)

	if args.size < 1
		@@deck = Array.new
		@@playerScore = 0
		@@playerHand = Array.new
		@@dealerHand = Array.new
		buildDeck
		deal(2, @@playerHand)
		deal(1, @@dealerHand)
		@@playerScore = checkScore(@@playerHand)
	else
		@@deck = args[0]
		@@playerHand = args[1]
		@@dealerHand = args[2]

		@@playerScore = checkScore(@@playerHand)
		@@dealerScore = checkScore(@@dealerHand)
	end
end

#ruby doesn't support multiple constructors...


def deck
	@@deck
end

def playerScore
	@@playerScore
end

def playerHand
	@@playerHand
end

def dealerHand
	@@dealerHand
end

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

def deal(numCards, hand)
	(1..numCards).each do |i|
		chosenCard = Random.rand(1..@@deck.length)
		hand.push(@@deck[chosenCard])
		@@deck.delete(chosenCard)
	end
end

def hit(hand)
	chosenCard = Random.rand(1..@@deck.length)
	hand.push(@@deck[chosenCard])
	@@deck.delete(chosenCard)
	checkScore(hand)
end


def checkScore(hand)
	score = 0;
	hand.each do |i|
		currentCard = i
		currentValue = currentCard[0]

		if currentValue === "T" || currentValue === "J" || currentValue === "Q" || currentValue === "K"
			score = score + 10
		elsif currentValue === "A"
			score = score + 11
		else
			score = score + currentValue.to_i
		end
	end

	return score
end

def gameLoop()
	while @@playerScore <= 21
		
		puts "Your hand: #{@@playerHand}"
		puts "Your score: #{@@playerScore}"
		puts "enter your move"
		move = ""
		move = gets.chomp

		if (move == "hit")
			hit(@@playerHand)
		end
		@@playerScore = checkScore(@@playerHand)
	end

	puts "you lost, or something broke lol"
end

end



