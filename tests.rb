require_relative 'blackjack'

bj = Blackjack.new
puts bj.instance_variable_get(:@playerHand)
#bj.gameLoop
